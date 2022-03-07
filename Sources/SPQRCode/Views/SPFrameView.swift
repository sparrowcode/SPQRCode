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

final class SPFrameView: UIView {

    // MARK: - Subviews

    private var shapeLayer = CAShapeLayer()
    private var maskLayer = CAShapeLayer()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        updateMaskLayer()
        updateShapeLayer()
    }

}

// MARK: - Private Methods

private extension SPFrameView {

    private func commonInit() {
        shapeLayer.mask = maskLayer
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25

        layer.masksToBounds = false
        layer.addSublayer(shapeLayer)
    }

    private func updateMaskLayer() {
        let minSide = max(shapeLayer.frame.width, shapeLayer.frame.height)
        let compressionRate: CGFloat = 2.0
        let minimumHole: CGFloat = 16
        let maximumRate: CGFloat = 0.25
        let rate = maximumRate + compressionRate / (minSide - minimumHole)
        let side = min(max(0, rate), 0.45) * minSide
        let size = CGSize(width: side, height: side)

        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: bounds.height - size.height),
            CGPoint(x: bounds.width - size.width, y: 0),
            CGPoint(x: bounds.width - size.width, y: bounds.height - size.height),
        ]

        let path = UIBezierPath()

        for point in points {
            let rect = CGRect(origin: point, size: size)
            let rectPath = UIBezierPath(rect: rect)
            path.append(rectPath)
        }

        maskLayer.path = path.cgPath
    }

    private func updateShapeLayer() {
        let lineWidth: CGFloat = 2.0
        let side = max(shapeLayer.frame.width, shapeLayer.frame.height)
        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
            cornerRadius: side * 15.0 / 180.0
        )

        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.frameColor.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth
    }

}
