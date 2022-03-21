//
//  ViewController.swift
//  SPQRCode
//
//  Created by Ivan Vorobei on 21.03.22.
//

import UIKit
import SPQRCode

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SPQRCode.scanning(
            detect: { data in
                switch data {
                case .ethWallet(let address):
                    return data
                default: return nil
                }
            }, handled: { data, controller in
                controller.dismiss(animated: true)
            },
            on: self
        )
    }
}

