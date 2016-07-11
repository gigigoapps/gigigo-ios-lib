//
//  QRGenerator.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 11/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation


public class QR {
	
	public class func generate(string: String) -> UIImage? {
		guard let outputImage: CIImage = self.generate(string) else { return nil }
		let image = UIImage(CIImage: outputImage)
		
		return image
	}
	
	public class func generate(string: String, onView: UIImageView) {
		guard let image: CIImage = self.generate(string) else { return }
		
		let scaleX = onView.frame.size.width / image.extent.size.width
		let scaleY = onView.frame.size.height / image.extent.size.height
		
		let transformedImage = image.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
		
		onView.image = UIImage(CIImage: transformedImage)
	}
	
	
	// MARK: - Private Helpers
	
	private class func generate(string: String) -> CIImage? {
		let stringData = string.dataUsingEncoding(NSUTF8StringEncoding)
		let filter = CIFilter(name: "CIQRCodeGenerator")
		filter?.setValue(stringData, forKey: "inputMessage")
		filter?.setValue("H", forKey: "inputCorrectionLevel")
		
		return filter?.outputImage
	}
	
}