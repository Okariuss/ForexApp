# ForexApp

ForexApp is an iOS application for tracking currency rates.

The project uses UIKit, MVVM-C, Swift 6, and Tuist.

## Requirements

- Xcode 26.5
- Tuist 4.118.1
- SwiftLint 0.65.0
- SwiftFormat 0.61.1

## Setup

Install the project tools and dependencies:

```sh
make setup
```

Generate the Xcode workspace:

```sh
make generate
```

## Development

Format the source files:

```sh
make format
```

Check formatting and code rules:

```sh
make format-check
make lint
```

Build and test the application:

```sh
make build
make test
```

Run all quality checks:

```sh
make check
```
