//
//  ImageDownloader.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/11/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

struct ImageDownloader {
	
	static let shared = ImageDownloader()
	static var requestsQueue: [UIImageView: Request] = [:]
	static var views: [UIImageView] = []
	static var images: [String: UIImage] = [:]
	
	
	private init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { _ in
			ImageDownloader.images = [:]
			ImageDownloader.views = []
			ImageDownloader.requestsQueue = [:]
		}
	}
	
	// MARK: - Public methods
	
	func download(url: String, for view: UIImageView, placeholder: UIImage?) {
        if let request = ImageDownloader.requestsQueue[view] {
            request.cancel()
            ImageDownloader.requestsQueue.removeValue(forKey: view)
        }
        guard let image = ImageDownloader.images[url] else {
            DispatchQueue.main.async {
                view.image = placeholder
            }
            return self.createRequest(url: url, in: view)
        }
        DispatchQueue.main.async {
            view.image = image
        }
    }
    
	// MARK: - Private Helpers
	
	private func createRequest(url: String, in view: UIImageView) {
		let request = Request(method: HTTPMethod.get.rawValue, baseUrl: url, endpoint: "")
		ImageDownloader.requestsQueue[view] = request
		ImageDownloader.views.append(view)
		
		if ImageDownloader.views.count <= 3 {
			self.downloadNext()
		}
	}
    
    private func downloadNext() {
        DispatchQueue.global().async {
            self.next()
        }
    }
    
	private func next() {
		guard let view = ImageDownloader.views.first,
            let request = ImageDownloader.requestsQueue[view] else {
            return
        }
        ImageDownloader.views.removeFirst()
		
		request.fetch { response in
			switch response.status {
                
            case .success:
                if let image = try? response.image() {
                    DispatchQueue(label: "com.gigigo.imagedownloader", qos: .background).async {
                        let resizedImage = self.resize(image: image, forView: view)
                        DispatchQueue.main.async {
                            self.handleSuccess(image: resizedImage, view: view, request: request)
                        }
                    }
                } else if let imageGif = try? response.gif() {
                    DispatchQueue.main.async {
                        self.handleSuccess(image: imageGif, view: view, request: request)
                    }
                } else {
                    LogWarn("Al descargar la imagen,o se ha recibido un body vacio o no se se ha reconocido el tipo de imagen que es.")
                    self.downloadNext()
                }
				
			default:
				LogError(response.error)
				self.downloadNext()
			}
		}
	}
	
    
    private func handleSuccess(image: UIImage, view: UIImageView, request: Request) {
        ImageDownloader.images.updateValue(image, forKey: request.baseURL)

        if let currentRequest = ImageDownloader.requestsQueue[view], request.baseURL == currentRequest.baseURL {
            self.setAnimated(image: image, in: view)
        }
        ImageDownloader.requestsQueue.removeValue(forKey: view)
        self.downloadNext()
    }
    
    private func resize(image: UIImage, forView view: UIView) -> UIImage {
        let width = view.width() * UIScreen.main.scale
        let height = view.height() * UIScreen.main.scale
        guard let imageResized = image.imageProportionally(with: CGSize(width: width, height: height)) else {
            return image
        }
        return imageResized
    }
    
	private func setAnimated(image: UIImage?, in view: UIImageView) {
		UIView.transition(
			with: view,
			duration:0.3,
			options: .transitionCrossDissolve,
			animations: {
				view.image = image
		},
			completion: nil
		)
	}
	
}
