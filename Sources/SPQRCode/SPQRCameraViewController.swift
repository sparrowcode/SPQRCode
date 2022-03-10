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

 Use `delegate` or `cameraFoundHandler` callback  to get recognition results.

 Example:

        let viewController = SPQRCameraViewController()
        otherViewController.present(viewController)
 */
open class SPQRCameraViewController: UIViewController {

    // MARK: - Private Static Properties

    private static let supportedCodeTypes = [
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.qr
    ]

    // MARK: - Public Properties

    public weak var delegate: SPQRCameraDelegate?
    public var cameraFoundHandler: SPQRCameraFoundHandler?
    public var cameraDidPressHandler: SPQRCameraHandlerDidPressHandler?

    public var customFrameView: UIView?
    public var customPreviewView: UIView?

    // MARK: - Private Properties

    private lazy var captureSession: AVCaptureSession = createCaptureSession()

    // MARK: - Sublayers

    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = createVideoPreviewLayer()
    private lazy var defaultFrameView = SPFrameView()
    private lazy var defaultPreviewView = SPPreviewLabel()

    private var frameView: UIView {
        customFrameView ?? defaultFrameView
    }
    private var previewView: UIView {
        customPreviewView ?? defaultPreviewView
    }

    // MARK: - Private Properties

    private var updateTimer: Timer?

    // MARK: - Lifecycle

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActions()
        configureSubviews()
        configureConstraints()
        captureSession.startRunning()
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        videoPreviewLayer.frame = view.layer.bounds
    }

    open func updateViews(result: SPQRCode) {
        if let updatableFrameView = frameView as? SPQRCodeUpdatable {
            updatableFrameView.update(for: result)
        }

        if let updatablePreviewView = previewView as? SPQRCodeUpdatable {
            updatablePreviewView.update(for: result)
        }
    }

    open func convert(object: AVMetadataMachineReadableCodeObject) -> SPQRCode? {
        guard let string = object.stringValue else {
            return nil
        }

        if let components = URLComponents(string: string), components.scheme != nil {
            if let url = components.url {
                return .url(url)
            }
        }

        if let pattern = try? NSRegularExpression(pattern: "^0x[a-fA-F0-9]{40}$") {
            let range = NSRange(location: 0, length: string.count)
            if pattern.firstMatch(in: string, range: range) != nil {
                return .ethWallet(string)
            }
        }

        return .text(string)
    }

    // MARK: - Actions

    @objc func previewDidPress(_ sender: UITapGestureRecognizer) {
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
        leadingPreviewConstraint.priority = .defaultLow

        let trailingPreviewConstraint = previewView.trailingAnchor.constraint(
            greaterThanOrEqualTo: frameView.trailingAnchor
        )
        trailingPreviewConstraint.priority = .defaultLow

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
        let previewViewTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(previewDidPress)
        )
        let frameViewTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(previewDidPress)
        )

        previewView.addGestureRecognizer(previewViewTapGesture)
        frameView.addGestureRecognizer(frameViewTapGesture)
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

        guard let result = convert(object: metadataObj) else {
            return
        }

        updateViews(result: result)
        notifyFound(result: result)

        if frameView.isHidden {
            frameView.frame = frame
        } else {
            let options: UIView.AnimationOptions = [
                .allowUserInteraction,
                .beginFromCurrentState,
                .curveEaseInOut,
            ]

            UIView.animate(withDuration: 0.2, delay: 0.0, options: options, animations: {
                self.frameView.frame = frame
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

        previewView.isHidden = false
        frameView.isHidden = false

        updateTimer?.invalidate()
        updateTimer = Timer(fire: Date(timeIntervalSinceNow: 0.8), interval: 2, repeats: false, block: { _ in
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
        videoPreviewLayer.videoGravity = .resizeAspectFill
        return videoPreviewLayer
    }

    private func notifyFound(result: SPQRCode) {
        if let delegate = delegate {
            delegate.camera(self, didFound: result)
        } else {
            cameraFoundHandler?(result)
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
