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

import Foundation
import CoreGraphics

struct SPQRCorner: Equatable {
    
    enum Kind: Int, CaseIterable {
        
        case topLeft = 0
        case bottomLeft = 1
        case bottomRight = 2
        case topRight = 3
        
        var verticalNeighbor: Kind {
            switch self {
            case .topLeft:
                return .bottomLeft
            case .bottomLeft:
                return .topLeft
            case .bottomRight:
                return .topRight
            case .topRight:
                return .bottomRight
            }
        }
        
        var horizontalNeighbor: Kind {
            switch self {
            case .topLeft:
                return .topRight
            case .bottomLeft:
                return .bottomRight
            case .bottomRight:
                return .bottomLeft
            case .topRight:
                return .topLeft
            }
        }
    }
    
    let kind: Kind
    let point: CGPoint
    
    let length: CGFloat
    let radius: CGFloat
    
    func startPoint(using corners: [SPQRCorner]) -> CGPoint? {
        guard let neighbor = corners.first(where: { self.kind.verticalNeighbor == $0.kind }) else {
            return nil
        }
        
        return pointOnLine(
            startPoint: point,
            endPoint: neighbor.point,
            distance: (length + radius)
        )
    }
    
    func preCurvePoint(using corners: [SPQRCorner]) -> CGPoint? {
        guard let neighbor = corners.first(where: { self.kind.verticalNeighbor == $0.kind }) else {
            return nil
        }
        
        return pointOnLine(
            startPoint: point,
            endPoint: neighbor.point,
            distance: radius
        )
    }
    
    func postCurvePoint(using corners: [SPQRCorner]) -> CGPoint? {
        guard let neighbor = corners.first(where: { self.kind.horizontalNeighbor == $0.kind }) else {
            return nil
        }
        
        return pointOnLine(
            startPoint: point,
            endPoint: neighbor.point,
            distance: radius
        )
    }
    
    func endPoint(using corners: [SPQRCorner]) -> CGPoint? {
        guard let neighbor = corners.first(where: { self.kind.horizontalNeighbor == $0.kind }) else {
            return nil
        }
        
        return pointOnLine(
            startPoint: point,
            endPoint: neighbor.point,
            distance: (length + radius)
        )
    }
    
    private func pointOnLine(startPoint: CGPoint, endPoint: CGPoint, distance: CGFloat = 0.0) -> CGPoint {
        let lDistance = endPoint.distance(from: startPoint)
        let vector = CGPoint(
            x: (endPoint.x - startPoint.x) / lDistance,
            y: (endPoint.y - startPoint.y) / lDistance
        )
        
        return .init(
            x: startPoint.x + distance * vector.x,
            y: startPoint.y + distance * vector.y
        )
    }
}
