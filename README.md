# APLWebKitExtension

This package provides extensions to commonly used `WebKit` Classes, like `WKWebView` and `WKUserContentController`.

Everything is written in Swift, documented and tested.

## Table of Contents

- [Overview of Classes and Functionalities](#overviewOfClassesAndFunctionalities)
- [Installation](#installation)
  - [Swift Package](#swiftpackage)
- [Usage](#usage)
- [License](#license)

## Overview of Classes and Functionalities

#### WKUserContentController Extension

- Add a specified JavaScript file as user script to a WKWebView.

#### WKWebView Extension

- Execute specified java script file.

#### HTTPCookie Extension

- Stringify an instance of a HTTPCookie into a string of key/value pairs.

#### WKHTTPCookieStore Extension

- Set/replace cookies asynchronously.
- Remove mutiple cookies at once.
- Get all cookies of all domains or from a specific one.

## Installation

### [Swift Package](https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescription.md#supportedplatform)

Just integrate the APLWebKitExtension via Xcode 11 ([tutorial](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)).

## Usage

After importing `APLWebKitExtension` all extensions and documentation can be accessed the default way.

An example of using the method `executeJavaScriptFile()` of the `WKWebView` extension:

```swift
import APLWebKitExtension

let wkWebView =  WKWebView(frame: .zero)
wkWebView.executeJavaScriptFile("jsFile", fileExtension: "js", completion: nil)
```

## License

**APLWebKitExtension** is created by apploft on 02.04.2020.
Copyright © 2019 apploft GmbH￼￼
MIT License · http://choosealicense.com/licenses/mit/
