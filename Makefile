project_name = SSGH
executable_name = ssgh

.PHONY : clean build test release xcodeproj lint deploy

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

# release:
# 	rm -f .build/$(executable_name).zip
# 	swift build -c release -Xswiftc -static-stdlib -Xswiftc -suppress-warnings
# 	.build/release/$(executable_name) --version
# 	zip -j .build/$(executable_name).zip .build/release/$(executable_name) LICENSE

# lint:
# 	pod spec lint --no-clean --allow-warnings

# deploy:
# 	pod trunk push $(project_name).podspec