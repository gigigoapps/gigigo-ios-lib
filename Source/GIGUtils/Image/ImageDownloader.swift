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
    static var queue: [UIImageView: Request] = [:]
    static var stack: [UIImageView] = []
    static var images: [String: UIImage] = [:]
    
    
    private init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { _ in
            ImageDownloader.images = [:]
            ImageDownloader.stack = []
            ImageDownloader.queue = [:]
        }
    }
    
    // MARK: - Public methods
    
    func download(url: String, for view: UIImageView, placeholder: UIImage?) {
        if let request = ImageDownloader.queue[view] {
            request.cancel()
            ImageDownloader.queue.removeValue(forKey: view)
        }
        
        if let image = ImageDownloader.images[url] {
            DispatchQueue.main.async {
                view.image = image
            }
        } else {
            DispatchQueue.main.async {
                view.image = placeholder
            }
            self.loadImage(url: url, in: view)
        }
    }
    
    // MARK: - Private Helpers
    
    private func loadImage(url: String, in view: UIImageView) {
        let request = Request(method: HTTPMethod.get.rawValue, baseUrl: url, endpoint: "")
        ImageDownloader.queue[view] = request
        ImageDownloader.stack.append(view)
        
        if ImageDownloader.queue.count <= 3 {
            self.downloadNext()
        }
    }
    
    private func downloadNext() {
        guard let view = ImageDownloader.stack.popLast() else { return }
        guard let request = ImageDownloader.queue[view] else {
            return
        }
        
        request.fetch { response in
            switch response.status {
                
            case .success:
                
                if let image = try? response.image() {
                    DispatchQueue(label: "com.gigigo.imagedownloader", qos: .background).async {
                        var finalImage = image
                        let width = view.width() * UIScreen.main.scale
                        let height = view.height() * UIScreen.main.scale
                        if let resized = image.imageProportionally(with: CGSize(width: width, height: height)) {
                            finalImage = resized
                            ImageDownloader.images.updateValue(finalImage, forKey: request.baseURL)
                        }
                        
                        DispatchQueue.main.async {
                            if let currentRequest = ImageDownloader.queue[view], request.baseURL == currentRequest.baseURL {
                                self.setAnimated(image: finalImage, in: view)
                            }                    
                            if let index = ImageDownloader.queue.index(forKey: view) {
                                ImageDownloader.queue.remove(at: index)
                            }
                            self.downloadNext()
                        }
                    }
                } else if let imageGif = try? response.gif() {
                    DispatchQueue.main.async {
                        ImageDownloader.images.updateValue(imageGif, forKey: request.baseURL)
                        
                        if let currentRequest = ImageDownloader.queue[view], request.baseURL == currentRequest.baseURL {
                            self.setAnimated(image: imageGif, in: view)
                        }
                        
                        if let index = ImageDownloader.queue.index(forKey: view) {
                            ImageDownloader.queue.remove(at: index)
                        }
                        self.downloadNext()
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
    
}
