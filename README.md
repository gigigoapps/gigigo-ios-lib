# GIGLibrary iOS

----
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)


Main library for Gigigo iOS projects.


## How to add it to my project

### Swift Package Manager

```swift
dependencies: [
.package(url: "https://github.com/gigigoapps/gigigo-swift-lib.git", .upToNextMajor(from: "0.1.0"))
]
```


## What is included

- Core:
	- SwiftNetwork: Swift classes to manage gigigo's requestst. Standard Gigigo JSON is parsed by default.
	- GIGUtils: a lot of extensions on foundation classes.
	- GIGScanner: QR scanner using native iOS API
	- ProgressPageControl: A page control with a progress bar in the selected page.
