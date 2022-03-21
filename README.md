# SPQRCode

<img src="https://user-images.githubusercontent.com/10995774/159240125-e95bdd73-63e8-42a7-b2fc-a3073f2d3f2b.PNG" height="550"/>

Filter with handling data and simple example.

```swift
SPQRCode.scanning(
  detect: { data in
    switch data {
    case .ethWallet(let address):
      return data
    default: return nil
    }
  }, 
  handled: { data, controller in
    controller.dismiss(animated: true)
  },
  on: self
)
```
