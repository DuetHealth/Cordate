[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Swift Package Manager](https://github.com/DuetHealth/Cordate/workflows/Swift%20Package%20Manager/badge.svg)](https://github.com/DuetHealth/Cordate/actions?query=workflow%3A%22Swift+Package+Manager%22) [![Carthage](https://github.com/DuetHealth/Cordate/workflows/Carthage/badge.svg)](https://github.com/DuetHealth/Cordate/actions?query=workflow%3ACarthage) [![Cocoapods](https://github.com/DuetHealth/Cordate/workflows/Cocoapods/badge.svg)](https://github.com/DuetHealth/Cordate/actions?query=workflow%3ACocoapods)

# Cordate

Cordate is a small library which makes working with dates much smoother by adding commonly-used extensions, custom UI components, and more.

## Usage

### Installation

Swift Package Manager: 
```
// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "CordateTestProject",
  dependencies: [
    .package(url: "https://github.com/DuetHealth/Cordate.git", from: "3.0.1")
  ],
  targets: [
    .target(name: "CordateTestProject", dependencies: ["Cordate"])
  ]
)
```

Cocoapods: `pod 'Cordate', '~> 3.0'`. See [Cordate.podspec](Cordate.podspec) for more information.

Carthage: `github "DuetHealth/Cordate" ~> 3.0 && carthage update`

## Roadmap

* Refactor calendar into a `CalendarView` class to enable greater reusability
* Add light-weight `DateFormatter` wrapper
* Rebuild `ManualDateField` using custom text logic

## License

Bedrock is MIT-licensed. The [MIT license](LICENSE) is included in the root of the repository.
