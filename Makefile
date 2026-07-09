SHELL := /bin/zsh

SCHEME ?= ForexApp
CONFIGURATION ?= Debug
DESTINATION ?= platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5,arch=arm64
TUIST_VERSION := 4.118.1

TEST_LANGUAGE ?= en
TEST_REGION ?= US
TEST_ALL_SCHEME ?= ForexApp-Workspace

TUIST := mise exec -- tuist
SWIFTFORMAT := mise exec -- swiftformat
SWIFTLINT := mise exec -- swiftlint

.PHONY: setup verify-tuist generate patch-tuist-macro-shell format format-check lint build test test-all check

setup:
	brew bundle
	mise install
	$(TUIST) install

verify-tuist:
	@test "$$($(TUIST) version)" = "$(TUIST_VERSION)" || \
		(echo "Expected Tuist $(TUIST_VERSION)." && exit 1)

generate:
	$(TUIST) generate --no-open
	$(MAKE) patch-tuist-macro-shell

patch-tuist-macro-shell:
	./scripts/patch-tuist-macro-shell.sh

format:
	$(SWIFTFORMAT) .

format-check:
	$(SWIFTFORMAT) . --lint

lint:
	$(SWIFTLINT) lint

build: generate
	xcodebuild -quiet \
		-workspace ForexApp.xcworkspace \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination '$(DESTINATION)' \
		build

test: generate
	xcodebuild -quiet \
		-workspace ForexApp.xcworkspace \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination '$(DESTINATION)' \
		-testLanguage $(TEST_LANGUAGE) \
		-testRegion $(TEST_REGION) \
		test
		
test-all: generate
	xcodebuild -quiet \
		-workspace ForexApp.xcworkspace \
		-scheme $(TEST_ALL_SCHEME) \
		-configuration $(CONFIGURATION) \
		-destination '$(DESTINATION)' \
		-testLanguage $(TEST_LANGUAGE) \
		-testRegion $(TEST_REGION) \
		test

check: format-check lint test-all
