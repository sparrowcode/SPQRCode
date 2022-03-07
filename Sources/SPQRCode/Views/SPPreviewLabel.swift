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

public class SPPreviewLabel: UILabel {

    private static let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

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

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + Self.insets.left + Self.insets.right,
            height: size.height + Self.insets.top + Self.insets.bottom
        )
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: Self.insets))
    }

}

private extension SPPreviewLabel {

    private func comminInit() {
        font = .preferredFont(forTextStyle: .caption1)
        clipsToBounds = true
        backgroundColor = .frameColor
        textColor = .black
        numberOfLines = 0
    }

}
