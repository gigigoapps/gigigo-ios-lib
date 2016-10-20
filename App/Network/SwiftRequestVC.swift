//
//  SwiftRequestVC.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez on 10/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import UIKit
import GIGLibrary


class SwiftRequestVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		LogManager.shared.logLevel = .debug
	}
	
	@IBAction func onButtonSwiftRequestTap(_ sender: UIButton) {
		let request = Request(
			method: "POST",
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
			method: "POST",
			baseUrl: "https://api.s.orchextra.io/v1",
			endpoint: "/security/token",
			bodyParams: [
				"grantType": "password",
				"identifier": "test@orchextra.io",
				"password": "GigigoMadrid1",
				"staySigned": true,
				"createCookie": false
			],
			verbose: true
		)
		.fetch(completionHandler: processResponse)
	}
	
	
	@IBAction func onButtonImageDownloadTap(_ sender: AnyObject) {
		Request(
			method: "GET",
			baseUrl: "http://api-discover-mcd.s.gigigoapps.com/media/image/qLXSBtDE/100/185/90",
			endpoint: "",
			verbose: true
		)
		.fetch(completionHandler: processResponse)

	}
	
	
	
	fileprivate func processResponse(_ response: Response) {
		switch response.status {

		case .success:
			Log("Success: \n\(try! response.json())")
		case .errorParsingJson, .noInternet, .sessionExpired, .timeout, .unknownError:
			Log("Some kind of error")
			LogError(response.error)
		case .apiError:
			Log("API error")
			LogError(response.error)
		}
        

        
	}
	
}
