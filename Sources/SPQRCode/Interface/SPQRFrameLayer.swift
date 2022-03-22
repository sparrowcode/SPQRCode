// The MIT License (MIT)
// Copyright © 2022 Sparrow Code (hello@sparrowcode.io)
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

class SPQRFrameLayer: CAShapeLayer {
    private let cLength: CGFloat
    private let cRadius: CGFloat
    
    // MARK: - Init
    
    init(
        length: CGFloat = 16.0,
        radius: CGFloat = 16.0,
        lineWidth: CGFloat = 5.0,
        lineColor: UIColor = .systemYellow
    ) {
        self.cLength = length
        self.cRadius = radius
        
        super.init()
        
        self.strokeColor = lineColor.cgColor
        self.fillColor = UIColor.clear.cgColor
        
        self.lineWidth = lineWidth
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func action(forKey event: String) -> CAAction? {
        if event == "path" {
            let animation: CABasicAnimation = .init(keyPath: event)
            
            animation.duration = 0.3
            animation.timingFunction = CATransaction.animationTimingFunction()
            
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    // MARK: - Actions
    
    func update(using points: [CGPoint]) {
        let corners = buildCorners(for: points)
        
        let framePath: UIBezierPath = .init()
        
        for corner in corners {
            guard let cStartPoint = corner.startPoint(using: corners),
                  let cPreCurvePoint = corner.preCurvePoint(using: corners),
                  let cPostCurvePoint = corner.postCurvePoint(using: corners),
                  let cEndPoint = corner.endPoint(using: corners)
            else { return }
            
            framePath.move(to: cStartPoint)
            framePath.addLine(to: cPreCurvePoint)
            framePath.addQuadCurve(to: cPostCurvePoint, controlPoint: corner.point)
            framePath.addLine(to: cEndPoint)
        }
        
        path = framePath.cgPath
    }
    
    func dissapear() {
        path = nil
    }
    
    private func buildCorners(for points: [CGPoint]) -> [SPQRCorner] {
        var corners: [SPQRCorner] = .init()
        
        for corner in SPQRCorner.Kind.allCases {
            corners.append(
                .init(
                    kind: corner,
                    point: points[corner.rawValue],
                    length: cLength,
                    radius: cRadius
                )
            )
        }
        
        return corners
    }
}
