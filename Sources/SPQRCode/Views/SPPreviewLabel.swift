// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public class SPPreviewLabel: UIView {

    // MARK: - Subviews

    private lazy var stackView = UIStackView()

    private lazy var iconImageView = UIImageView()
    private lazy var label = UILabel()
    private lazy var chevronImageView = UIImageView()

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)
        comminInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.midY, 16)
    }

}

// MARK: - SPQRCodeUpdatable

extension SPPreviewLabel: SPQRCodeUpdatable {

    public func update(for result: SPQRCode) {
        switch result {
        case .text(let string):
            label.text = string
            iconImageView.setImage(systemName: "doc.plaintext.fill")
        case .url(let url):
            label.text = url.host
            iconImageView.setImage(systemName: "safari.fill")
        case .ethWallet(let string):
            label.text = string
            iconImageView.setImage(systemName: "bitcoinsign.circle.fill")
        }
    }

}

// MARK: - Private Methods

private extension SPPreviewLabel {

    private func comminInit() {
        configureView()
        configureSubviews()
        configureConstraints()
    }

    private func configureView() {
        isUserInteractionEnabled = true
        clipsToBounds = true
        backgroundColor = .previewColor

        addSubview(stackView)

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(chevronImageView)

        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentHuggingPriority(.required, for: .vertical)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func configureSubviews() {
        if #available(iOS 13.0, *) {
            iconImageView.tintColor = .black
            chevronImageView.tintColor = .gray
            chevronImageView.image = UIImage(systemName: "chevron.right")
            chevronImageView.contentMode = .scaleAspectFit
            chevronImageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 12, weight: .medium))
            iconImageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 13, weight: .medium))
        } else {
            iconImageView.isHidden = true
            chevronImageView.isHidden = true
        }

        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0

        stackView.axis = .horizontal
        stackView.setCustomSpacing(4, after: iconImageView)
        stackView.setCustomSpacing(8, after: label)
    }

    private func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

}
