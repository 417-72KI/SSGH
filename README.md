# SSGH - ShootingStar for GitHub
[![Actions Status](https://github.com/417-72KI/SSGH/workflows/Test/badge.svg)](https://github.com/417-72KI/SSGH/actions)
[![GitHub release](https://img.shields.io/github/release/417-72KI/SSGH/all.svg)](https://github.com/417-72KI/SSGH/releases)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![Platform](https://img.shields.io/badge/Platforms-macOS%7CLinux-blue.svg)](https://github.com/417-72KI/SSGH)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/417-72KI/SSGH/master/LICENSE)

**SSGH** is a utility tool for starring in GitHub.  
You can star all repos for the specific user.

## Requirement
- macOS 10.15 or newer

## Installation
### Mint

```sh
mint install 417-72KI/SSGH@1.1.1
```

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
