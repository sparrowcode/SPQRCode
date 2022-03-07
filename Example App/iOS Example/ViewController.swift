//
//  ViewController.swift
//  iOS Example
//
//  Created by Nikita Somenkov on 06.03.2022.
//

import UIKit
import SPQRCode

class ViewController: UIViewController {

    private lazy var label = UILabel()
    private lazy var stackView = UIStackView()
    private lazy var simplePresent = UIButton(configuration: .borderedTinted(), primaryAction: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(stackView)

        label.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
        ])

        stackView.addArrangedSubview(simplePresent)

        simplePresent.setTitle("Show Scanner", for: .normal)
        simplePresent.addTarget(self, action: #selector(showScanner), for: .touchUpInside)

        label.text = "Detected:\n---"
    }

    @objc private func showScanner() {
        let vc = SPQRCameraViewController()

        vc.cameraFoundHandler = { [weak self] value in
            self?.label.text = "Detected:\n" + value
        }
        vc.cameraDidPressHandler = { [weak vc] in
            vc?.dismiss(animated: true, completion: nil)
        }

        present(vc, animated: true, completion: nil)
    }

}

