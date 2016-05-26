//
//  GIGScannerViewController.swift
//  GiGLibrary
//
//  Created by Judith Medina on 7/5/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import AVFoundation

protocol GIGScannerDelegate {
    
    func didSuccessfullyScan(scannedValue: String, tye: String)
}

class GIGScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var delegate: GIGScannerDelegate?
    private let session: AVCaptureSession
    private let device: AVCaptureDevice
    private let output: AVCaptureMetadataOutput
    private var preview: AVCaptureVideoPreviewLayer?
    private var input: AVCaptureDeviceInput?

    
    // MARK: - INIT
    
    required init?(coder aDecoder: NSCoder) {
        
        self.session = AVCaptureSession()
        self.device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        self.output = AVCaptureMetadataOutput()
        
        do {
            self.input = try AVCaptureDeviceInput(device: device)
        }
        catch _ {
            //Error handling, if needed
        }
        
        
        super.init(coder: aDecoder)
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        self.setupScannerWithProperties()
    }
    
    
    // MARK: - PUBLIC
    
    func isCameraAvailable() -> Bool {
        
       let authCamera = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch authCamera {
            
        case AVAuthorizationStatus.Authorized:
            return true
            
        case AVAuthorizationStatus.Denied:
            return false
            
        case AVAuthorizationStatus.Restricted:
            return false
            
        case AVAuthorizationStatus.NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { success in
                return true
            })
            return true
        }
    }
    
    func setupScanner(metadataObject: [AnyObject]?) {
        guard let metadata = metadataObject else {return}
        self.output.metadataObjectTypes = [metadata]
        
        if self.output.availableMetadataObjectTypes.count > 0 {
            self.output.metadataObjectTypes = metadata
        }
    }
    
    func startScanning() {
        self.session.startRunning()
    }
    
    func stopScanning() {
        self.session.stopRunning()
    }
    
    func enableTorch(enable: Bool) {

        try! self.device.lockForConfiguration()
        
        if self.device.hasTorch {
            
            if enable {
                self.device.torchMode = .On
            }
            else {
                self.device.torchMode = .Off
            }

        }
        
        self.device.unlockForConfiguration()
    }
    
    func focusCamera(focusPoint: CGPoint) {
        
        do {
            try self.device.lockForConfiguration()
            self.device.focusPointOfInterest = focusPoint
            self.device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
            self.device.exposurePointOfInterest = focusPoint
            self.device.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - PRIVATE
    
    func setupScannerWithProperties() {
        
        if self.session.canAddInput(self.input) {
            self.session.addInput(self.input)
        }
        self.session.addOutput(self.output)
        self.output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        self.setupScanner(self.setupOutputWithDefaultValues())
        self.setupPreviewLayer()
    }
    
    func setupOutputWithDefaultValues() -> [String] {
        let metadata = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                        AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                        AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeQRCode];
        
        return metadata
    }
    
    func setupPreviewLayer() {
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.preview?.frame = self.view.bounds
        self.view.layer.addSublayer(self.preview!)
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
        for metadata in metadataObjects {
            
            let readableCode = metadata as? AVMetadataMachineReadableCodeObject
            guard   let value = readableCode?.stringValue,
                    let type = readableCode?.type
                else {return}
            
                self.delegate?.didSuccessfullyScan(value, tye: type)
        }
    }
    
}
