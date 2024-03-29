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
    .package(url: "https://github.com/DuetHealth/Cordate.git", from: "3.0.3")
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
