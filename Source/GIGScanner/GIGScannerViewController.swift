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
    
    func didSuccessfullyScan(_ scannedValue: String, tye: String)
}

class GIGScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var delegate: GIGScannerDelegate?
    fileprivate let session: AVCaptureSession
    fileprivate let device: AVCaptureDevice
    fileprivate let output: AVCaptureMetadataOutput
    fileprivate var preview: AVCaptureVideoPreviewLayer?
    fileprivate var input: AVCaptureDeviceInput?

    
    // MARK: - INIT
    
    required init?(coder aDecoder: NSCoder) {
        
        self.session = AVCaptureSession()
        self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
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
        
       let authCamera = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authCamera {
            
        case AVAuthorizationStatus.authorized:
            return true
            
        case AVAuthorizationStatus.denied:
            return false
            
        case AVAuthorizationStatus.restricted:
            return false
            
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { success in
//                return true
            })
            return true
        }
    }
    
    func setupScanner(_ metadataObject: [AnyObject]?) {
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
    
    func enableTorch(_ enable: Bool) {

        try! self.device.lockForConfiguration()
        
        if self.device.hasTorch {
            
            if enable {
                self.device.torchMode = .on
            }
            else {
                self.device.torchMode = .off
            }

        }
        
        self.device.unlockForConfiguration()
    }
    
    func focusCamera(_ focusPoint: CGPoint) {
        
        do {
            try self.device.lockForConfiguration()
            self.device.focusPointOfInterest = focusPoint
            self.device.focusMode = AVCaptureFocusMode.continuousAutoFocus
            self.device.exposurePointOfInterest = focusPoint
            self.device.exposureMode = AVCaptureExposureMode.continuousAutoExposure
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
        self.output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        self.setupScanner(self.setupOutputWithDefaultValues() as [AnyObject]?)
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
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
    
        for metadata in metadataObjects {
            
            let readableCode = metadata as? AVMetadataMachineReadableCodeObject
            guard   let value = readableCode?.stringValue,
                    let type = readableCode?.type
                else {return}
            
                self.delegate?.didSuccessfullyScan(value, tye: type)
        }
    }
    
}
