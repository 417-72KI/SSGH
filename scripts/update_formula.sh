#!/bin/zsh

set -euo pipefail

trap catch ERR
trap finally EXIT

function catch {
    echo '\e[31mAborted\e[m'
}
function finally {
    rm -rf ./tmp
}

TAG=$(swift run ssgh --version 2>/dev/null)

if [[ "$TAG" != "$(git describe --exact-match --tags 2>/dev/null)" ]]; then
    echo '\e[31m[ERROR] Must run on tag.\e[m'
    exit 1
fi

PROJECT_NAME=$1
EXECUTABLE_NAME=$2

FORMULA_PATH="${EXECUTABLE_NAME}.rb"
FORMULA_URL="https://api.github.com/repos/417-72KI/homebrew-tap/contents/$FORMULA_PATH"
CURRENT_FORMULA=`curl -sS -X GET $FORMULA_URL | jq -c .`
FORMULA_CONTENT=`echo "${CURRENT_FORMULA}" | tr -d '[:cntrl:]' | jq -r '.content'`
SHA=`echo "${CURRENT_FORMULA}" | tr -d '[:cntrl:]' | jq -r '.sha'`

echo '\e[33mdownload source\e[m' 1>&2
gh release download $TAG --archive=tar.gz -D ./tmp
echo '\e[33mdownload assets\e[m' 1>&2
gh release download $TAG -D ./tmp

SHA256_SOURCE=$(shasum -a 256 ./tmp/${PROJECT_NAME}-${TAG}.tar.gz | awk '{ print $1 }')
SHA256_MACOS=$(shasum -a 256 ./tmp/${EXECUTABLE_NAME}-macos-v${TAG}.zip | awk '{ print $1 }')
SHA256_LINUX=$(shasum -a 256 ./tmp/${EXECUTABLE_NAME}-linux-v${TAG}.zip | awk '{ print $1 }')
CONTENT_FORMATTED="$(
    cat ${FORMULA_PATH}.tmpl \
    | sed -e "s/{{TAG}}/${TAG}/"g \
    | sed -e "s/{{SHA256_SOURCE}}/$SHA256_SOURCE/"g \
    | sed -e "s/{{SHA256_MACOS}}/$SHA256_MACOS/"g \
    | sed -e "s/{{SHA256_LINUX}}/$SHA256_LINUX/"g
)"
echo "\e[32mFormatted formula:\n$CONTENT_FORMATTED\n\e[m"
CONTENT_ENCODED=$(echo $CONTENT_FORMATTED | openssl enc -e -base64 | tr -d '\n ')

if [[ "${CONTENT_ENCODED}" == "${FORMULA_CONTENT}" ]]; then
    echo '\e[33m[WARN] Content not modified.\e[m'
    exit 0
fi

COMMIT_MESSAGE="Update ${EXECUTABLE_NAME} to ${TAG}"

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
    curl -sS -X PUT $FORMULA_URL \
        -H "Content-Type:application/json" \
        -H "Authorization:token $GITHUB_TOKEN" \
        -d "{
            \"path\":\"$FORMULA_PATH\",
            \"sha\":\"$SHA\",
            \"content\":\"$CONTENT_ENCODED\",
            \"message\":\"$COMMIT_MESSAGE\"
        }" \
        | jq .
else
    echo '\e[31mAbort.\e[m'
fi
