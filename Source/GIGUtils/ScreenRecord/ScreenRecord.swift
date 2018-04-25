//
//  ScreenRecord.swift
//  GIGLibrary
//
//  Created by eduardo parada pardo on 25/4/18.
//  Copyright © 2018 eduardo parada pardo. All rights reserved.
//

import Foundation
import ReplayKit

protocol ScreenRecordUI: class {
    func dismissView()
    func showPreview(viewController: UIViewController)
    func errorRecording(error: Error)
}

protocol ScreenRecordInput {
    func startRecording()
    func stopRecording()
}

class ScreenRecord: NSObject {
    
    weak var view: ScreenRecordUI?
    var recorder: RPScreenRecorder
    
    override init() {
        self.recorder = RPScreenRecorder.shared()
        self.recorder.isMicrophoneEnabled = true
    }
}

// MARK: ScreenRecordInput
extension ScreenRecord: ScreenRecordInput {
    
    func startRecording() {
        if #available(iOS 10.0, *) {
            self.recorder.startRecording { [unowned self] (error) in
                if let unwrappedError = error {
                    self.view?.errorRecording(error: unwrappedError)
                }
            }
        }
    }
    
    func stopRecording() {
        if #available(iOS 10.0, *) {
            self.recorder.stopRecording { [unowned self] (preview, error) in
                if let unwrappedPreview = preview {
                    unwrappedPreview.previewControllerDelegate = self
                    self.view?.showPreview(viewController: unwrappedPreview)
                }
                if let unwrappedError = error {
                    self.view?.errorRecording(error: unwrappedError)
                }
            }
        }
    }
}

// MARK: RPPreviewViewControllerDelegate
extension ScreenRecord: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.view?.dismissView()
    }
}
