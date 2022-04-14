#!/bin/zsh

set -euo pipefail

trap catch ERR
trap finally EXIT

function catch {
    echo '\e[31mExit with error\e[m'
}
function finally {
    rm -rf ./tmp
}

EXECUTABLE_NAME=$1

FORMULA_PATH="${EXECUTABLE_NAME}.rb"
FORMULA_URL="https://api.github.com/repos/417-72KI/homebrew-${EXECUTABLE_NAME}/contents/$FORMULA_PATH"
SHA=`curl -sS -X GET $FORMULA_URL | jq -r '.sha'`
echo "sha: '$SHA'"

TAG=$(swift run ssgh --version 2>/dev/null)

gh release download $TAG -D ./tmp

SHA256_MACOS=$(shasum -a 256 ./tmp/${EXECUTABLE_NAME}-macos-v${TAG}.zip | awk '{ print $1 }')
SHA256_LINUX=$(shasum -a 256 ./tmp/${EXECUTABLE_NAME}-linux-v${TAG}.zip | awk '{ print $1 }')
CONTENT_FORMATTED="$(
    cat ${FORMULA_PATH}.tmpl \
    | sed -e "s/{{TAG}}/${TAG}/"g \
    | sed -e "s/{{SHA256_MACOS}}/$SHA256_MACOS/"g \
    | sed -e "s/{{SHA256_LINUX}}/$SHA256_LINUX/"g
)"
echo "\e[33mFormatted formula:\n$CONTENT_FORMATTED\n\e[m"
CONTENT_ENCODED=$(echo $CONTENT_FORMATTED | openssl enc -e -base64 | tr -d '\n ')
# echo "content_encoded: \n$CONTENT_ENCODED"

COMMIT_MESSAGE="Update version to ${TAG}"

while :
do
    read "INPUT?Confirmed?(y/N): "
    case "$INPUT" in
        [yY] ) ACCEPTED=1; break ;;
        [nN] ) ACCEPTED=0; break ;;
        * ) echo '\e[31mInvalid input.\e[m';;
    esac
done

if [ $ACCEPTED -eq 1 ]; then
    curl -i -X PUT $FORMULA_URL \
       -H "Content-Type:application/json" \
       -H "Authorization:token $GITHUB_TOKEN" \
       -d \
    "{
      \"path\":\"$FORMULA_PATH\",
      \"sha\":\"$SHA\",
      \"content\":\"$CONTENT_ENCODED\",
      \"message\":\"$COMMIT_MESSAGE\"
    }"
else
    echo '\e[31mAborted.\e[m'
fi
