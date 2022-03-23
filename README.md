# SPQRCode

<img src="https://user-images.githubusercontent.com/10995774/159624802-497afa7c-70f5-4bd5-893b-dfe01818456b.jpeg" height="550"/>

## Installation

Ready for use on iOS 13+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/SPQRCode", .upToNextMajor(from: "1.0.2"))
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
    on: self
)
```

If you want allow handle only specific type, like url or Ethereum wallet, in `detect` handler retun nil if you don't want handle current QR code data.


