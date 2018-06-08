//
//  ScreenRecordVC.swift
//  GIGLibrary
//
//  Created by eduardo parada pardo on 25/4/18.
//  Copyright © 2018 Gigigo SL. All rights reserved.
//

import UIKit

class ScreenRecordVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    let screenRecord = ScreenRecord(microphoneEnable: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenRecord.view = self
    }
        
    @IBAction func startRecording() {
        self.titleLabel.text = "Recording"
        self.screenRecord.startRecording()
    }
    
    @IBAction func stopRecording() {
        self.titleLabel.text = "Stop"
        self.screenRecord.stopRecording()
    }
    
    @IBAction func open(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ScreenRecordVC: ScreenRecordUI {
    
    // MARK: ScreenRecordUI
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    func showPreview(viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
    func errorRecording(error: Error) {
        print(error.localizedDescription)
    }
}
