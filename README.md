# SPQRCode

<img src="https://user-images.githubusercontent.com/10995774/159624802-497afa7c-70f5-4bd5-893b-dfe01818456b.jpeg" height="550"/>

### iOS Dev Community

<p float="left">
    <a href="https://twitter.com/i/communities/1730194338489987403">
        <img src="https://cdn.sparrowcode.io/github/badges/x-community.png?version=1" height="52">
    </a>
    <a href="#apps-using">
        <img src="https://cdn.sparrowcode.io/github/badges/download-on-the-appstore.png?version=4" height="52">
    </a>
</p>

## Installation

Ready for use on iOS 13+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/SPQRCode", .upToNextMajor(from: "1.0.4"))
]
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SPQRCode` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

Example for handle QRCode.

```swift
SPQRCode.scanning(
    detect: { data, controller in
        return data
    }, 
    handled: { data, controller in
        controller.dismiss(animated: true)
    },
    on: viewController
)
```

If you want allow handle only specific type, like url or Ethereum wallet, in `detect` handler retun `nil` if you don't want handle current QR code data.


