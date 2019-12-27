#!/bin/zsh

set -eu

if ! type "mint" > /dev/null; then
    echo '`mint` not found. Install'
    brew install mint
fi

CORRECTED_FILES=$(mint run swiftlint swiftlint autocorrect 2> /dev/null | grep Corrected | awk '{ print $1 }' | sed -E 's/(.*\.swift):([0-9]*):([0-9]*)/\1/')

git add $CORRECTED_FILES
git commit -m 'Autocorrect by SwiftLint'
