//
//  LiveTimeViewController.swift
//  FindYourFace
//
//  Created by Roman on 9/5/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class LiveTimeViewController: UIViewController {
    
    lazy var presenter = LiveTimeViewControllerPresenter(with: self)
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
        
    let button: UIButton = {
       let tmpButton = UIButton()
        tmpButton.addTarget(self, action: #selector(buttonMethod), for: .touchUpInside)
        tmpButton.backgroundColor = UIColor.blue
        tmpButton.setTitleColor(.white, for: .normal)
        tmpButton.setTitle("Dissmiss", for: .normal)
        return tmpButton
    }()
    
    let resultView = UIView()
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    let captureQueue = DispatchQueue(label: "captureQueue")
    var visionRequests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupResultView()
        setupResultLabel()
        presenter.view?.setupCamera()
        setupButton()
    }
    
    @objc func buttonMethod() {
        presenter.view?.dismissController()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.frame
    }
    
}

//MARK: - UI Configuration
extension LiveTimeViewController {
    func setupButton() {
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupResultView() {
        self.view.addSubview(resultView)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        resultView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        resultView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        resultView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        resultView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }
    
    func setupResultLabel() {
        self.view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.topAnchor.constraint(equalTo: self.resultView.bottomAnchor).isActive = true
        resultLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        resultLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        resultLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

//MARK: - Presenter Protocol Declaration
extension LiveTimeViewController: LiveTimeViewControllerPresenterView {
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func handleClassifications(request: VNRequest, error: Error?) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           self.present(alert, animated: true)
            return
        }
        guard let results = request.results as? [VNClassificationObservation] else {
            print("No results")
            return
        }
        
        DispatchQueue.main.async {
            let str = results.first?.identifier ?? "Nothing,"
            let array = str.components(separatedBy: ",")
            self.resultLabel.text = "Result is: \(array.first ?? "Nothing")\nConfidence: \((results.first?.confidence ?? 0) * 100)%"
        }
    }
    
    func setupCamera() {
        guard let camera = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            resultView.layer.addSublayer(previewLayer)
            
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            session.sessionPreset = .high
            session.addInput(cameraInput)
            session.addOutput(videoOutput)
            
            let connection = videoOutput.connection(with: .video)
            connection?.videoOrientation = .portrait
            session.startRunning()
            
            guard let visionModel = try? VNCoreMLModel(for: MobileNetV2().model) else {
                fatalError("Could not load model")
            }
            
            let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: handleClassifications)
            classificationRequest.imageCropAndScaleOption = .centerCrop
            visionRequests = [classificationRequest]
        } catch {
            let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension LiveTimeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions: [VNImageOption: Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 1)!, options: requestOptions)
        do {
            try imageRequestHandler.perform(visionRequests)
        } catch {
             let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           self.present(alert, animated: true)
        }
    }
}
