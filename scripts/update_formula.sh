#!/bin/zsh

set -eu

EXECUTABLE_NAME=$1

FORMULA_PATH="${EXECUTABLE_NAME}.rb"
FORMULA_URL="https://api.github.com/repos/417-72KI/homebrew-${EXECUTABLE_NAME}/contents/$FORMULA_PATH"
SHA=`curl GET $FORMULA_URL | jq -r '.sha'`
echo "sha: \n$SHA"

TAG=$(swift run ssgh --version 2>/dev/null)

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