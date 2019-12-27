project_name = SSGH
executable_name = ssgh

.PHONY : dependencies clean build test release xcode

default: clean build

clean:
	swift package clean
	git clean -xf

dependencies:
	swift package update

build:
	swift build

test:
	swift test

release:
	scripts/release.sh ${executable_name}
