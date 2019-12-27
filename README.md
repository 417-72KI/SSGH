# SSGH - ShootingStar for GitHub
[![Actions Status](https://github.com/417-72KI/SSGH/workflows/Test/badge.svg)](https://github.com/417-72KI/SSGH/actions)
[![GitHub release](https://img.shields.io/github/release/417-72KI/SSGH/all.svg)](https://github.com/417-72KI/SSGH/releases)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/417-72KI/SSGH/master/LICENSE)

SSGH is a utility tool for gifting stars in GitHub.

## Requirement
- macOS 10.14 or newer

## Installation
### Homebrew

```sh
brew tap 417-72KI/SSGH
brew install ssgh
```

## Before use
SSGH needs GitHub token

Genarate page is here↓↓

https://github.com/settings/tokens

*repo* scope is required.

## Usage
```sh
export SSGH_TOKEN='{generated-token}'
ssgh {user-id-of-target}
```
