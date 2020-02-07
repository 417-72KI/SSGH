#!/bin/zsh

set -eu

APPLICATION_INFO_FILE='Sources/SSGHCore/Common/ApplicationInfo.swift'

if [ `git symbolic-ref --short HEAD` != 'master' ]; then
    echo 'Release is enabled only in master.'
    exit 1
fi

if [ "$(git status -s | grep "${APPLICATION_INFO_FILE}")" = '' ]; then
    echo "\e[31m${APPLICATION_INFO_FILE} is not modified.\e[m"
    exit 1
fi

if [ "$(git status -s | grep .swift | grep -v ApplicationInfo.swift)" != '' ]; then
    echo "\e[31mUnexpected added/modified/deleted file.\e[m"
    exit 1
fi

if ! type "github-release" > /dev/null; then
    echo '`github-release` not found. Install'
    go get github.com/aktau/github-release
fi

cd $(git rev-parse --show-toplevel)

# Version
TAG=$(cat "${APPLICATION_INFO_FILE}" | grep version | awk '{ print $NF }' | sed -E 's/Version\(\"(.*)\"\)/\1/')
if [ "$(git tag | grep ${TAG})" != '' ]; then
    echo "\e[31mTag: '${TAG}' already exists.\e[m"
    exit 1
fi

# Build
EXECUTABLE_NAME=$1
rm -f .build/${EXECUTABLE_NAME}.zip
swift build -c release -Xswiftc -suppress-warnings
zip -j .build/${EXECUTABLE_NAME}.zip .build/release/${EXECUTABLE_NAME} LICENSE

# TAG
git commit -m "Bump version to ${TAG}" "${APPLICATION_INFO_FILE}"
git tag ${TAG}
git push origin master "${TAG}"

export GITHUB_TOKEN=$SSGH_TOKEN

# GitHub Release
github-release release \
    --user 417-72KI \
    --repo SSGH \
    --tag ${TAG}

github-release upload \
    --user 417-72KI \
    --repo SSGH \
    --tag ${TAG} \
    --name "${EXECUTABLE_NAME}.zip" \
    --file .build/${EXECUTABLE_NAME}.zip

FORMULA_PATH="${EXECUTABLE_NAME}.rb"
FORMULA_URL="https://api.github.com/repos/417-72KI/homebrew-${EXECUTABLE_NAME}/contents/$FORMULA_PATH"
SHA=`curl GET $FORMULA_URL | jq -r '.sha'`
echo "sha: \n$SHA"

SHA256=$(shasum -a 256 .build/${EXECUTABLE_NAME}.zip | cut -d ' ' -f 1)
CONTENT_ENCODED=`cat ${FORMULA_PATH}.tmpl | sed -e "s/{{TAG}}/${TAG}/" | sed -e "s/{{SHA256}}/$SHA256/" | openssl enc -e -base64 | tr -d '\n '`
echo "content_encoded: \n$CONTENT_ENCODED"

COMMIT_MESSAGE="Update version to ${TAG}"

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