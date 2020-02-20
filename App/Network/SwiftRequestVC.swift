//
//  SwiftRequestVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 10/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary

class Test: LoggableModule {
    static var logLevel: LogLevel {
        set {
            try? LogManager.shared.setLogLevel(newValue, forModule: self)
        }
        get {
            return LogManager.shared.logLevel(forModule: self) ?? .none
        }
    }
    
    static var logStyle: LogStyle {
        set {
            try? LogManager.shared.setLogStyle(newValue, forModule: self)
        }
        get {
            return LogManager.shared.logStyle(forModule: self) ?? .none
        }
    }
}

class SwiftRequestVC: UIViewController {
	
    let reachability: ReachabilityWrapper = ReachabilityWrapper.shared
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.reachability.delegate = self
		LogManager.shared.logLevel = .debug
        Test.logLevel = .debug
        Test.logStyle = .funny
	}
	
    @IBAction func onButtonDownloadFile(_ sender: Any) {
        let request = Request(
            method: HTTPMethod.post.rawValue,
            baseUrl: "https://s3-eu-west-1.amazonaws.com/ferringo-ci/Pruebas/3DModels/fly-optimized.scnassets.zip",
            endpoint: "",
            headers: [:]
        )
        request.verbose = true
        
        let documentsDirectoryURL = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        guard let finalURL = documentsDirectoryURL?.appendingPathComponent("fly-optimized.scnassets.zip", isDirectory: false) else { return LogWarn("Error when append text") }
        
        
        request.fetch(withDownloadUrlFile: finalURL) { response in
            
        }
    }
    
	@IBAction func onButtonSwiftRequestTap(_ sender: UIButton) {
		let request = Request(
			method: HTTPMethod.post.rawValue,
			baseUrl: "https://api-discover-mcd.q.gigigoapps.com",
			endpoint: "/configuration",
			headers: [
				"x-app-version": "IOS_2.1",
				"x-app-country": "BR",
				"x-app-language": "es",
			]
		)
		request.verbose = true
		request.fetch(completionHandler: processResponse)
	}
	
	@IBAction func onButtonOrchextraApiRequestTap(_ sender: AnyObject) {
		Request(
			method: HTTPMethod.post.rawValue,
			baseUrl: "https://api.s.orchextra.io/v1",
			endpoint: "/security/token",
			bodyParams: [
				"grantType": "password",
				"identifier": "test@orchextra.io",
				"password": "12345",
				"staySigned": true,
				"createCookie": false
			],
			verbose: true,
            logInfo: DefaultRequestLogInfo(module: Test.self, logLevel: .error)
		)
		.fetch(completionHandler: processResponse)
	}
		
	@IBAction func onButtonImageDownloadTap(_ sender: AnyObject) {
		Request(
			method: HTTPMethod.get.rawValue,
			baseUrl: "http://api-discover-mcd.s.gigigoapps.com/media/image/qLXSBtDE/100/185/90?query1=1&query2=2",
			endpoint: "",
			urlParams: [
				"query2": "2",
				"query3": "3"
			],
			verbose: true
		)
		.fetch(completionHandler: processResponse)

	}
    
    @IBAction func onButtonRequestNoGigigoTap(_ sender: AnyObject) {
        Request(
            method: HTTPMethod.get.rawValue,
            baseUrl: "http://private-3b5b1-ejemplo13.apiary-mock.com/ejemplo13/questions/a",
            endpoint: "",
            verbose: true,
            standard: .basic
            )
            .fetch(completionHandler: processResponse)
    }
	
    @IBAction func onButtonMcdonalLogin(_ sender: AnyObject) {
        var AppHeaders: [String: String] {
            return [
                "X-app-version": "IOS_2.3",
                "X-app-country": "BR",
                "X-app-language": "es"
            ]
        }
        
        let request = Request(
            method: HTTPMethod.post.rawValue,
            baseUrl: "https://api-discover-mcd.q.gigigoapps.com",
            endpoint: "/security/login",
            headers: AppHeaders,
            bodyParams: [
                "grantType": "password",
                "email" : "eduardo.parada@gigigo.com",
                "password" : "12345",
                "deviceId" : UIDevice.current.identifierForVendor?.uuidString ?? "No identifier"
            ],
            verbose: true
        )
        
        request.fetch { response in
            switch response.status {
                
            case .success:
                print("success")
                break
            case .errorParsingJson:
                print("❌❌❌ errorParsingJson")
                break
            case .sessionExpired:
                print("❌❌❌ sessionExpired")
                break
            case .timeout:
                print("❌❌❌ timeout")
                break
            case .noInternet:
                print("❌❌❌ noInternet")
                break
            case .apiError:
                let dataString = String(data: response.body!, encoding: String.Encoding.utf8)
                print("❌❌❌ apiError code: \(response.error!.code) - dataString: \(String(describing: dataString))")
                break
            case .unknownError:
                print("❌❌❌ unknownError")
                break
                
            case .untrustedCertificate:
                print("❌❌❌ untrustedCertificate")
                break
            }
        }
        
    }
    
    @IBAction func onButtonUploadFile(_ sender: AnyObject) {
        
        let request = Request(
            method: HTTPMethod.post.rawValue,
            baseUrl: "https://catbox.moe",
            endpoint: "/user/api.php",
            verbose: true
        )
        
        let fileUploadData = FileUploadData(
            data: UIImage(named: "gigigo_office")!.pngData()!,
            mimeType: "image/png",
            filename: "gigigo_office",
            name: "fileToUpload"
        )
        
        request.upload(
        file: fileUploadData,
        params: ["reqtype": "fileupload"]) { response in
            guard let body = response.body, let decodedBody = String(data: body, encoding: .utf8) else { return }
            LogInfo("Uploaded to: \(decodedBody)")
        }
    }

	fileprivate func processResponse(_ response: Response) {
		switch response.status {

		case .success:
			Log("Success: \n\(String(describing: try? response.json()))")
        case .noInternet:
            Log("No internet")
            LogError(response.error)
        case .errorParsingJson, .sessionExpired, .timeout, .unknownError:
			Log("Some kind of error")
			LogError(response.error)
		case .apiError:
			Log("API error")
			LogError(response.error)
        case .untrustedCertificate:
            Log("untrustedCertificate")
            LogError(response.error)
        }
	}
}

extension SwiftRequestVC: ReachabilityWrapperDelegate {
    func reachabilityChanged(with status: NetworkStatus) {
        switch status {
        case .notReachable:
            Log("Network status not reachable")
        case .reachableViaWiFi:
            Log("Network status reachable via Wifi")
        case .reachableViaMobileData:
            Log("Network status reachable via data")
        }
    }
}
