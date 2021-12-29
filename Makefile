DARTANALYZER_FLAGS=--fatal-warnings

build: lib/*dart test/*dart deps
	dartanalyzer ${DARTANALYZER_FLAGS} lib/
	dartfmt -n --set-exit-if-changed lib/ test/
	fvm spawn latest test --coverage --coverage-path ./coverage/lcov.info

deps: pubspec.yaml
	flutter packages get -v

reformatting:
	dartfmt -w lib/ test/

build-local: reformatting build
	genhtml -o coverage coverage/lcov.info
	lcov --list coverage/lcov.info
	lcov --summary coverage/lcov.info
	open coverage/index.html

build-dev: lib/ test/ deps-dev
	dartanalyzer ${DARTANALYZER_FLAGS} lib/
	dartfmt -n --set-exit-if-changed lib/ test/
	fvm spawn latest test --coverage --coverage-path ./coverage/lcov.info

deps-dev: pubspec.yaml
	fvm spawn latest packages get -v

build-local-dev: reformatting build-dev
	genhtml -o coverage coverage/lcov.info
	lcov --list coverage/lcov.info
	lcov --summary coverage/lcov.info
	open coverage/index.html

# Build split Apk Bundle for both ARM-ARM64
apk-split-dev:
	fvm spawn latest packages get
	fvm spawn latest build apk --target-platform android-arm,android-arm64 --split-per-abi -v
	open `PWD`/build/app/outputs/apk/release/