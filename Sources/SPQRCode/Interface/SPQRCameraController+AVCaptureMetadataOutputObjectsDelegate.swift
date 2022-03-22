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
import AVKit

extension SPQRCameraController: AVCaptureMetadataOutputObjectsDelegate {
    
    open func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard !metadataObjects.isEmpty else { return }
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard Self.supportedCodeTypes.contains(object.type) else { return }
        guard let detectedData = convert(object: object) else { return }
        let observingData = detectQRCodeData(detectedData, self)
        guard let transformedObject = previewLayer.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject else { return }
        
        let points = transformedObject.corners
        
        // Update Detail
        
        if let data = observingData {
            let splitter = ": "
            switch data {
            case .url(let url):
                detailView.setTitle(data.prefix + splitter + url.absoluteString)
                detailView.setImage(data.iconImage)
            case .text(let text):
                detailView.setTitle(data.prefix + splitter + text)
                detailView.setImage(data.iconImage)
            case .ethWallet(let address):
                detailView.setTitle(data.prefix + splitter + address)
                detailView.setImage(data.iconImage)
            }
        }
        
        
        if let bottomPoint = points.max(by: { $0.y < $1.y }) {
            if let secondBottomPoint = points.sorted(by: { $0.y < $1.y }).dropLast().max(by: { $0.y < $1.y }) {
                let maxX = max(bottomPoint.x, secondBottomPoint.x)
                let minX = min(bottomPoint.x, secondBottomPoint.x)
                
                let updateDetailFrame = {
                    self.detailView.sizeToFit()
                    let maximumDetailWidth = self.view.frame.width * 0.9
                    if self.detailView.frame.width > maximumDetailWidth {
                        self.detailView.frame.setWidth(maximumDetailWidth)
                    }
                    self.detailView.center.x = minX + ((maxX - minX) / 2)
                    self.detailView.frame.origin.y = bottomPoint.y + 16
                }
                
                let animated = !detailView.isHidden
                if animated {
                    UIView.animate(withDuration: 0.3, delay: .zero, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                        updateDetailFrame()
                    }, completion: nil)
                } else {
                    updateDetailFrame()
                }
            }
        }
        
        qrCodeData = observingData
        
        // Update Frame
        
        frameLayer.update(using: points)
        
        // Timer
        
        updateTimer?.invalidate()
        updateTimer = Timer(fire: Date(timeIntervalSinceNow: 0.8), interval: 1, repeats: false, block: { _ in
            self.qrCodeData = nil
            self.frameLayer.dissapear()
        })
        
        RunLoop.main.add(updateTimer!, forMode: .default)
    }
    
    open func convert(object: AVMetadataMachineReadableCodeObject) -> SPQRCodeData? {
        
        guard let string = object.stringValue else { return nil }
        
        if let components = URLComponents(string: string), components.scheme != nil {
            if let url = components.url {
                return .url(url)
            }
        }
        
        let regex =  "^0x[a-fA-F0-9]{40}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: string){
            return .ethWallet(string)
        }
        
        return .text(string)
    }
}
