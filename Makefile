DARTANALYZER_FLAGS=--fatal-warnings

build: lib/*dart test/*dart deps
	dartanalyzer ${DARTANALYZER_FLAGS} lib/
	dartfmt -n --set-exit-if-changed lib/ test/
	flutter test --coverage --coverage-path ./coverage/lcov.info

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
	flutter-dev test --coverage --coverage-path ./coverage/lcov.info

deps-dev: pubspec.yaml
	flutter-dev packages get -v

build-local-dev: reformatting build-dev
	genhtml -o coverage coverage/lcov.info
	lcov --list coverage/lcov.info
	lcov --summary coverage/lcov.info
	open coverage/index.html