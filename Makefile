SHELL := /bin/zsh

SCHEME ?= ForexApp
CONFIGURATION ?= Debug
DESTINATION ?= platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5
TUIST_VERSION := 4.118.1

TEST_LANGUAGE ?= en
TEST_REGION ?= US

.PHONY: setup verify-tuist generate format format-check lint build test check

setup: verify-tuist
	brew bundle
	tuist install

verify-tuist:
	@test "$$(tuist version)" = "$(TUIST_VERSION)" || \
		(echo "Expected Tuist $(TUIST_VERSION)." && exit 1)

generate:
	tuist generate --no-open

format:
	swiftformat .

format-check:
	swiftformat . --lint

lint:
	swiftlint lint

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

check: format-check lint test
