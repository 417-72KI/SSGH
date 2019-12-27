#!/bin/zsh

set -eu

if ! type "mint" > /dev/null; then
    echo '`mint` not found. Install'
    brew install mint
fi

mint run swiftlint swiftlint autocorrect
