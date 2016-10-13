//
//  UIImageExtension.swift
//  GiGLibrary
//
//  Created by Sergio López on 11/10/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func imageFromUrl(urlString: String) {
        
        let request = Request(method: "GET", baseUrl: urlString, endpoint: "")
        request.fetchImage{ (response) in
            if response.status == .success {
                guard let image = try? response.image() else { return }
                self.image = image
            }
        }
    }
}
