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
import SparrowKit
import AVKit
import NativeUIKit

open class SPQRCameraController: SPController {
    
    open var detectQRCodeData: ((SPQRCodeData)->SPQRCodeData?) = { data in return data }
    open var handledQRCodeData: ((SPQRCodeData, SPQRCameraController)->Void?)? = nil

    internal var updateTimer: Timer?
    internal lazy var captureSession: AVCaptureSession = makeCaptureSession()
    internal var qrCodeData: SPQRCodeData? { didSet { self.updateInterface() }}
    
    // MARK: - Views
    
    internal let handleButton = NativeLargeActionButton().do {
        $0.setTitle(Texts.action_handle)
        $0.setColorise(.init(content: .black, background: .systemYellow), for: .default)
        let dimmedColorise = SPDimmedButton.Colorise(content: .dimmedContent, background: .dimmedBackground.alpha(0.5))
        $0.setColorise(dimmedColorise, for: .dimmed)
        $0.setColorise(dimmedColorise, for: .disabled)
    }
    
    internal let cancelButton = SPDimmedButton().do {
        $0.setTitle(Texts.action_cancel)
        $0.applyDefaultAppearance(with: .init(content: .systemYellow, background: .clear))
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, addPoints: -1)
    }
    
    internal let frameLayer = SPQRFrameLayer()
    internal let detailView = SPQRDetailButton()
    internal lazy var previewLayer = makeVideoPreviewLayer()
    
    public override init() {
        super.init()
        modalPresentationStyle = .fullScreen
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layoutMargins = .init(horizontal: 20, vertical: .zero)
        view.layer.addSublayer(previewLayer)
        view.layer.addSublayer(frameLayer)
        captureSession.startRunning()
        
        view.addSubview(detailView)
        view.addSubviews(handleButton, cancelButton)
        
        handleButton.addTarget(self, action: #selector(didTapHandledButton), for: .touchUpInside)
        
        updateInterface()
    }
    
    // MARK: - Actions
    
    @objc func didTapHandledButton() {
        guard let data = qrCodeData else { return }
        handledQRCodeData?(data, self)
    }
    
    // MARK: - Layout
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cancelButton.sizeToFit()
        cancelButton.setXCenter()
        cancelButton.frame.setMaxY(view.frame.height - view.safeAreaInsets.bottom - NativeLayout.Spaces.default_more)
        
        handleButton.layout(maxY: cancelButton.frame.origin.y - NativeLayout.Spaces.default)
        
        previewLayer.frame = .init(
            x: .zero, y: .zero,
            width: view.layer.bounds.width,
            height: handleButton.frame.origin.y - NativeLayout.Spaces.default_more
        )
    }
    
    // MARK: - Internal
    
    internal func updateInterface() {
        let duration: TimeInterval = 0.22
        if qrCodeData != nil {
            detailView.isHidden = false
            UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseInOut, animations: {
                self.detailView.transform = .identity
                self.detailView.alpha = 1
                self.handleButton.isEnabled = true
            })
        } else {
            UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseInOut, animations: {
                self.detailView.transform = .init(scale: 0.9)
                self.detailView.alpha = .zero
                self.handleButton.isEnabled = false
            }, completion: { _ in
                self.detailView.isHidden = true
            })
        }
    }
    
    internal static let supportedCodeTypes = [
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.qr
    ]
    
    internal func makeVideoPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        return videoPreviewLayer
    }
    
    internal func makeCaptureSession() -> AVCaptureSession {
        let captureSession = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { fatalError() }
        guard let input = try? AVCaptureDeviceInput(device: device) else { fatalError() }
        captureSession.addInput(input)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = Self.supportedCodeTypes
        return captureSession
    }
}

