# Cordate

[![CI](https://github.com/DuetHealth/Cordate/actions/workflows/ci.yml/badge.svg)](https://github.com/DuetHealth/Cordate/actions/workflows/ci.yml)

Cordate is a small library which makes working with dates much smoother by adding commonly-used extensions, custom UI components, and more.

## Usage

### Installation

Swift Package Manager:
```swift
// swift-tools-version:6.2

import PackageDescription

let package = Package(
  name: "CordateTestProject",
  dependencies: [
    .package(url: "https://github.com/DuetHealth/Cordate.git", from: "5.0.0")
  ],
  targets: [
    .target(name: "CordateTestProject", dependencies: ["Cordate"])
  ]
)
```

## Roadmap

* Refactor calendar into a `CalendarView` class to enable greater reusability
* Add light-weight `DateFormatter` wrapper
* Rebuild `ManualDateField` using custom text logic

## License

Cordate is MIT-licensed. The [MIT license](LICENSE) is included in the root of the repository.
