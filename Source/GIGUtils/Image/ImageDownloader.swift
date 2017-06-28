//
//  ImageDownloader.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 3/11/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit

typealias ImageDownloadCompletion = (UIImage?, NSError?) -> Void

struct ImageDownloader {
	
	static let shared = ImageDownloader()
	static var queue: [UIImageView: (Request, ImageDownloadCompletion?)] = [:]
	static var stack: [UIImageView] = []
	static var images: [String: UIImage] = [:]
    
	init() {
		NotificationCenter.default.addObserver(forName: .UIApplicationDidReceiveMemoryWarning, object: nil, queue: nil) { _ in
			ImageDownloader.images.removeAll()
			ImageDownloader.stack.removeAll()
			ImageDownloader.queue.removeAll()
		}
	}
	
	// MARK: - Public methods
	
    func download(url: String, for view: UIImageView, placeholder: UIImage?, completion: ImageDownloadCompletion? = nil) {
		if let request = ImageDownloader.queue[view] {
			request.0.cancel()
            request.1?(nil, NSError(message: "Request cancelled"))
			ImageDownloader.queue.removeValue(forKey: view)
		}
		
		if let image = ImageDownloader.images[url] {
			view.image = image
            completion?(image, nil)
		} else {
			view.image = placeholder
			self.loadImage(url: url, in: view, completion: completion)
		}
	}
	
	// MARK: - Private Helpers
	
    private func loadImage(url: String, in view: UIImageView, completion: ImageDownloadCompletion? = nil) {
		let request = Request(method: "GET", baseUrl: url, endpoint: "")
		ImageDownloader.queue[view] = (request, completion)
		ImageDownloader.stack.append(view)
		
		if ImageDownloader.queue.count <= 3 {
			self.downloadNext()
		}
	}
	
	private func downloadNext() {
		guard let view = ImageDownloader.stack.popLast() else { return }
		guard let request = ImageDownloader.queue[view]?.0 else { return }
		
		request.fetch { response in
			switch response.status {
				
			case .success:
				DispatchQueue(label: "com.gigigo.imagedownloader", qos: .background).async {
					if let image = try? response.image() {
						let width = view.width() * UIScreen.main.scale
						let height = view.height() * UIScreen.main.scale
						let resized = image.imageProportionally(with: CGSize(width: width, height: height))
						ImageDownloader.images[request.baseURL] = resized
						
						DispatchQueue.main.sync {
							if let currentRequest = ImageDownloader.queue[view], request.baseURL == currentRequest.0.baseURL {
                                currentRequest.1?(resized, nil)
								self.setAnimated(image: resized, in: view)
                            }
							
							if let index = ImageDownloader.queue.index(forKey: view) {
								ImageDownloader.queue.remove(at: index)
							}
							self.downloadNext()
						}
					} else {
                        let completion = self.completionHandler(for: view, with: request)
                        completion?(nil, NSError(message: "Unable to load image"))
						self.downloadNext()
					}
				}
				
			default:
                let completion = self.completionHandler(for: view, with: request)
                completion?(nil, NSError(message: "Request failed"))
				LogError(response.error)
				self.downloadNext()
			}
		}
	}
	
	private func setAnimated(image: UIImage?, in view: UIImageView) {
		UIView.transition(
			with: view,
			duration:0.4,
			options: .transitionCrossDissolve,
			animations: {
				view.image = image
		},
			completion: nil
		)
	}
    
    private func completionHandler(for view: UIImageView, with request: Request) -> ImageDownloadCompletion? {
        if let currentRequest = ImageDownloader.queue[view], currentRequest.0.baseURL == request.baseURL, let completion = currentRequest.1 {
            return completion
        }
        return nil
    }
    
}
