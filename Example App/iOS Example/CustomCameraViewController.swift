//
//  ViewController.swift
//  iOS Example
//
//  Created by Nikita Somenkov on 06.03.2022.
//

import Foundation
import SPQRCode
import UIKit
import AVFoundation

final class CustomCameraViewController: SPQRCameraViewController {

    private lazy var frameView = UIView()
    private lazy var label = UILabel()

    override func viewDidLoad() {
        frameView.layer.cornerRadius = 8
        frameView.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 3.0
        frameView.layer.shadowColor = UIColor.black.cgColor
        frameView.layer.shadowOpacity = 0.3

        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.3

        customFrameView = frameView
        customPreviewView = UIView()

        super.viewDidLoad()

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
        ])
    }

}
