import UIKit
import SPQRCode

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SPQRCode.scanning(
            detect: { data, controller in
                return data
            }, handled: { data, controller in
                controller.dismiss(animated: true)
            },
            on: self
        )
    }
}

