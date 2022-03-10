//
//  ViewController.swift
//  iOS Example
//
//  Created by Nikita Somenkov on 06.03.2022.
//

import UIKit
import SPQRCode

class ViewController: UIViewController {

    private lazy var titleLabel = UILabel()
    private lazy var resultLabel = UILabel()
    private lazy var stackView = UIStackView()
    private lazy var showCustomScannerButton = createCustomButton()
    private lazy var showBasicScannerButton = createBasicButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(resultLabel)
        view.addSubview(stackView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),

            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),

            showCustomScannerButton.heightAnchor.constraint(equalToConstant: 48),
            showBasicScannerButton.heightAnchor.constraint(equalToConstant: 48),
        ])

        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.addArrangedSubview(showCustomScannerButton)
        stackView.addArrangedSubview(showBasicScannerButton)

        titleLabel.text = "Detected:"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)

        resultLabel.numberOfLines = 0
        resultLabel.textColor = .secondaryLabel
    }

    @objc private func showBasicScanner() {
        let vc = SPQRCameraViewController()

        vc.cameraFoundHandler = { [weak self] value in
            switch value {
            case .text(let string):
                self?.resultLabel.text = "Text: '\(string)'"
            case .ethWallet(let wallet):
                self?.resultLabel.text = "ETH Wallet: '\(wallet)'"
            case .url(let url):
                self?.resultLabel.text = "Text: '\(url.absoluteString)'"
            }
        }
        vc.cameraDidPressHandler = { [weak vc] in
            vc?.dismiss(animated: true, completion: nil)
        }

        present(vc, animated: true, completion: nil)
    }

    @objc private func showCustomScanner() {
        let vc = CustomCameraViewController()

        vc.cameraFoundHandler = { [weak self] value in
            switch value {
            case .text(let string):
                self?.resultLabel.text = "Text: '\(string)'"
            case .ethWallet(let wallet):
                self?.resultLabel.text = "ETH Wallet: '\(wallet)'"
            case .url(let url):
                self?.resultLabel.text = "Text: '\(url.absoluteString)'"
            }
        }
        vc.cameraDidPressHandler = { [weak vc] in
            vc?.dismiss(animated: true, completion: nil)
        }

        present(vc, animated: true, completion: nil)
    }

    private func createBasicButton() -> UIButton {
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.contentInsets.top = 8
        configuration.contentInsets.bottom = 8
        configuration.title = "Show Basic Scanner"
        configuration.cornerStyle = .dynamic

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(showBasicScanner), for: .touchUpInside)
        return button
    }

    private func createCustomButton() -> UIButton {
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.contentInsets.top = 8
        configuration.contentInsets.bottom = 8
        configuration.title = "Show Custom Scanner"
        configuration.cornerStyle = .dynamic

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(showCustomScanner), for: .touchUpInside)
        return button
    }
}

