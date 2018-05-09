//
//  ScreenRecord.swift
//  GIGLibrary
//
//  Created by eduardo parada pardo on 25/4/18.
//  Copyright © 2018 eduardo parada pardo. All rights reserved.
//

import Foundation
import ReplayKit

public protocol ScreenRecordUI: class {
    func dismissView()
    func showPreview(viewController: UIViewController)
    func errorRecording(error: Error)
}

public protocol ScreenRecordInput {
    func startRecording()
    func stopRecording()
}

open class ScreenRecord: NSObject {
    
    public weak var view: ScreenRecordUI?
    var recorder: RPScreenRecorder
    
    public override init() {
        self.recorder = RPScreenRecorder.shared()
        self.recorder.isMicrophoneEnabled = true
    }
}

// MARK: ScreenRecordInput
extension ScreenRecord: ScreenRecordInput {
    
    open func startRecording() {
        if #available(iOS 10.0, *) {
            self.recorder.startRecording { [unowned self] (error) in
                if let unwrappedError = error {
                    self.view?.errorRecording(error: unwrappedError)
                }
            }
        }
    }
    
    open func stopRecording() {
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
    
    public func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.view?.dismissView()
    }
}
