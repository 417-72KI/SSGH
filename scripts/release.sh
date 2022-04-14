#!/bin/zsh

set -eu

EXECUTABLE_NAME=$1
APPLICATION_INFO_FILE_NAME='ApplicationInfo.swift'
APPLICATION_INFO_FILE_PATH="$(find Sources -name "${APPLICATION_INFO_FILE_NAME}")"

if [ `git symbolic-ref --short HEAD` != 'main' ]; then
    echo 'Release is enabled only in main.'
    exit 1
fi

if [ "$(git status -s | grep "${APPLICATION_INFO_FILE_PATH}")" = '' ]; then
    echo "\e[31m${APPLICATION_INFO_FILE_PATH} is not modified.\e[m"
    exit 1
fi

if [ "$(git status -s | grep .swift | grep -v ${APPLICATION_INFO_FILE_NAME})" != '' ]; then
    echo "\e[31mUnexpected added/modified/deleted file.\e[m"
    exit 1
fi

if ! type "gh" > /dev/null; then
    echo '`gh` not found. Install'
    brew install gh
fi

cd $(git rev-parse --show-toplevel)

# Version
TAG=$(swift run ssgh --version 2>/dev/null)
if [ "$(git tag | grep -E "^${TAG}$")" != '' ]; then
    echo "\e[31mTag: '${TAG}' already exists.\e[m"
    exit 1
fi

# TAG
git commit -m "Bump version to ${TAG}" "${APPLICATION_INFO_FILE_PATH}"
git push origin main

# Release
gh release create ${TAG}
