project_name = SSGH
executable_name = ssgh

.SILENT:
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

lint:
	mint run SwiftLint swiftlint

autocorrect:
	scripts/autocorrect.sh

release:
	scripts/release.sh ${executable_name}

formula:
	scripts/update_formula.sh ${executable_name}
