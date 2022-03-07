# SPQRCode

QR code detector. Simple usage, you can get recognition results via delegate or callback.

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Manually](#manually)
- [Usage](#usage)

## Installation

Ready for use on iOS 11+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/SPQRCode", .upToNextMajor(from: "1.0.0"))
]
```

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager. For usage and installation instructions, visit their website. To integrate using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SPQRCode'
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SPSafeSymbols` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

To show QRCode scanner:

```swift
let qrCodeController = SPQRCodeViewController()

qrCodeController.cameraFoundHandler = { value in
    print(value)
}

viewController.present(qrCodeController, animated: true, completion: nil)
```

If need with specific view for frame and preview, use this:

```swift
let frameView = UIView()
frameView.layer.borderWidth = 3.0

let previewLabel = UILabel()

let qrCodeController = SPQRCodeViewController()
qrCodeController.customFrameView = frameView
qrCodeController.customPreviewView = previewLabel

qrCodeController.cameraFoundHandler = { [weak previewLabel] value in
    previewLabel?.text = value
}

viewController.present(qrCodeController, animated: true, completion: nil)
```

Optionaly you can create subclass of `SPQRCodeViewController` for more control
