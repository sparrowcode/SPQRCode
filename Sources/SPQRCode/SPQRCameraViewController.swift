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
import AVFoundation

/**
 SPQRCameraViewController:  Main view. Can be customisable if need.

 For change duration, check method `present` and pass duration and other specific property if need customise.

 Here available set window on which shoud be present.
 If you have some windows, you shoud configure it. Check property `presentWindow`.

 For disable dismiss by tap, check property `.dismissByTap`.

 Recomended call `SPAlert` and choose style func.
 */
open class SPQRCameraViewController: UIViewController {

    // MARK: - Private Static Properties

    private static let supportedCodeTypes = [
        AVMetadataObject.ObjectType.upce,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.qr
    ]

    // MARK: - Public Properties

    public weak var delegate: SPQRCameraDelegate?
    public var cameraFoundHandler: SPQRCameraFoundHandler?
    public var cameraDidPressHandler: SPQRCameraHandlerDidPressHandler?

    private lazy var frameView: UIView = SPFrameView()
    private lazy var previewView: UIView = SPPreviewLabel()

    // MARK: - Private Properties

    private lazy var captureSession: AVCaptureSession = createCaptureSession()

    // MARK: - Sublayers

    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = createVideoPreviewLayer()

    // MARK: - Private Properties

    private var updateTimer: Timer?

    // MARK: - Lifecycle

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActions()
        configureSubviews()
        configureConstraints()
        captureSession.startRunning()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        videoPreviewLayer.frame = view.layer.bounds
    }

    open func updatePreviewView(for object: AVMetadataMachineReadableCodeObject) {
        if let previewView = previewView as? SPPreviewLabel {
            previewView.text = object.stringValue
        }
    }

    // MARK: - Actions

    @objc private func previewDidPress() {
        notifyDidPress()
    }

}

// MARK: - Private Methods

private extension SPQRCameraViewController {

    private func configureView() {
        view.layer.addSublayer(videoPreviewLayer)
        view.addSubview(frameView)
        view.addSubview(previewView)
    }

    private func configureSubviews() {
        frameView.backgroundColor = .clear
        frameView.isHidden = true
        previewView.isHidden = true
    }

    private func configureConstraints() {
        previewView.translatesAutoresizingMaskIntoConstraints = false

        let centerPreviewConstraint = previewView.centerXAnchor.constraint(
            equalTo: frameView.centerXAnchor
        )
        centerPreviewConstraint.priority = .defaultLow

        let leadingPreviewConstraint = previewView.leadingAnchor.constraint(
            lessThanOrEqualTo: frameView.leadingAnchor
        )
        leadingPreviewConstraint.priority = .defaultHigh

        let trailingPreviewConstraint = previewView.trailingAnchor.constraint(
            greaterThanOrEqualTo: frameView.trailingAnchor
        )
        trailingPreviewConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            centerPreviewConstraint,
            leadingPreviewConstraint,
            trailingPreviewConstraint,
            previewView.topAnchor.constraint(equalTo: frameView.bottomAnchor, constant: 16),
            previewView.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            previewView.trailingAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            previewView.topAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
        ])
    }

    private func configureActions() {
        previewView.isUserInteractionEnabled = true
        frameView.isUserInteractionEnabled = true

        previewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previewDidPress)))
        frameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previewDidPress)))
    }

}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension SPQRCameraViewController: AVCaptureMetadataOutputObjectsDelegate {

    open func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        guard !metadataObjects.isEmpty else {
            return
        }

        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }

        guard Self.supportedCodeTypes.contains(metadataObj.type) else {
            return
        }

        guard let frame = calculateFrame(for: metadataObj) else {
            return
        }

        guard let qrString = metadataObj.stringValue else {
            return
        }

        updatePreviewView(for: metadataObj)
        notifyFound(string: qrString)

        if frameView.isHidden {
            frameView.frame = frame
        } else {
            UIView.animate(withDuration: 0.3) {
                self.frameView.frame = frame
                self.view.layoutIfNeeded()
            }
        }

        previewView.isHidden = false
        frameView.isHidden = false

        updateTimer?.invalidate()
        updateTimer = Timer(fire: Date(timeIntervalSinceNow: 0.5), interval: 2, repeats: false, block: { _ in
            self.frameView.isHidden = true
            self.previewView.isHidden = true
        })

        RunLoop.main.add(updateTimer!, forMode: .default)
    }

}

private extension SPQRCameraViewController {

    private func createCaptureSession() -> AVCaptureSession {
        let captureSession = AVCaptureSession()

        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("developer error: we cannot find any device with type 'AVMediaType.video'")
        }

        guard let input = try? AVCaptureDeviceInput(device: device) else {
            fatalError("developer error: we cannot initialize input device, note: simulator do not support")
        }

        captureSession.addInput(input)

        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)

        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = Self.supportedCodeTypes

        return captureSession
    }

    private func createVideoPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return videoPreviewLayer
    }

    private func notifyFound(string: String) {
        if let delegate = delegate {
            delegate.camera(self, didFound: string)
        } else {
            cameraFoundHandler?(string)
        }
    }

    private func notifyDidPress() {
        if let delegate = delegate {
            delegate.cameraDidPress(self)
        } else {
            cameraDidPressHandler?()
        }
    }

    private func calculateFrame(for object: AVMetadataMachineReadableCodeObject) -> CGRect? {
        let points = object.corners.map {
            return CGPoint(
                x: view.bounds.width - view.bounds.width * $0.y,
                y: view.bounds.height * $0.x
            )
        }

        if points.isEmpty {
            return nil
        }

        let yPoints = points.map(\.y)
        let xPoints = points.map(\.x)

        let yPointsMin = yPoints.min()!
        let yPointsMax = yPoints.max()!
        let xPointsMin = xPoints.min()!
        let xPointsMax = xPoints.max()!

        let xWidth = xPointsMax - xPointsMin
        let yWidth = yPointsMax - yPointsMin
        let width = max(xWidth, yWidth)

        return CGRect(x: xPointsMin, y: yPointsMin, width: width, height: width)
    }

}
