project_name = SSGH
executable_name = ssgh

.PHONY : dependencies clean build test release xcode

default: clean build

clean:
	swift package clean
	git clean -xdf -e .build

xcode:
	swift package generate-xcodeproj
	ruby -e "require 'xcodeproj'" \
	-e "project_path = './$(project_name).xcodeproj'" \
	-e "project = Xcodeproj::Project.open(project_path)" \
	-e "project.targets.each do |target|" \
    -e "if target.uuid.start_with?(\"$(project_name)::\") then" \
	-e "phase = project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)" \
	-e "phase.shell_script = \"if which swiftlint >/dev/null; then\n  swiftlint\nelse\n  echo \\\"warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint\\\"\nfi\"" \
	-e "target.build_phases << phase" \
	-e "end" \
	-e "end" \
	-e "project.save"
	open $(project_name).xcodeproj

dependencies:
	swift package update

build:
	swift build

test:
	swift test

release:
	scripts/release.sh ${executable_name}
