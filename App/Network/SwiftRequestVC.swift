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
		
		LogManager.shared.logLevel = .Debug
	}
	
	@IBAction func onButtonSwiftRequestTap(sender: UIButton) {
		let request = Request(
			method: "POST",
			baseUrl: "http://api-discover-mcd.s.gigigoapps.com",
			endpoint: "/configuration"
		)
		request.verbose = true
		
		request.fetchJson(processResponse)
	}
	
	@IBAction func onButtonOrchextraApiRequestTap(sender: AnyObject) {
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
		.fetchJson(processResponse)
	}
	
	
	private func processResponse(response: Response) {
		switch response.status {

		case .Success:
			Log("Success: \n\(response.body!)")
		case .ErrorParsingJson, .NoInternet, .SessionExpired, .Timeout, .UnknownError:
			Log("Some kind of error")
			LogError(response.error)
		case .ApiError:
			Log("API error")
			LogError(response.error)
		}
	}
	
}
