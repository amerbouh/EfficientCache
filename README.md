# EfficientCache

A lightweight and performance-focused library to persist simple objects in the cache and on-disk. 

## Requirements

- Xcode 11+
- Target of iOS 11.0 or higher

## Installation

### Cocoapods

Cocoapods is currently not supported by Efficient Cache.

### Swift Package Manager

Efficient Cache can be installed using the [Swift Package Manager](https://swift.org/package-manager/), a tool developed by Apple to automate the distribution of Swift code. 

To add Efficient Cache to an Xcode project, use Xcode's `Swift Packages` options located within the `File` menu. A prompt will be displayed with a search bar to enter the repository URL of the package you wish to add. Copy [Efficient Cache's URL](https://github.com/anas-merbouh/EfficientCache.git) and click on `Next. You will be presented with various options for version requirements. Choose the one that best suits your preferences.

To add Efficent Cache as a dependency, you only need to add it to the `dependencies` value of the `Package.swift` file.

```swift
dependencies: [
    .package(url: "https://github.com/anas-merbouh/EfficientCache.git", .upToNextMajor(from: "1.0.0"))
]
```
