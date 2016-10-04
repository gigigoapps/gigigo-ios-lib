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
			method: "GET",
			baseUrl: "http://api-discover-mcd.s.gigigoapps.com",
			endpoint: "/configuration",
			urlParams: [
                "this_is": "a_trout",
                "probando": "repeticion"
            ]
		)
		request.verbose = true
		
		request.fetchJson(processResponse)
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
		.fetchJson(processResponse)
	}
	
	
	@IBAction func onButtonImageDownloadTap(_ sender: AnyObject) {
		Request(
			method: "GET",
			baseUrl: "http://api-discover-mcd.s.gigigoapps.com/media/image/qLXSBtDE/100/185/90",
			endpoint: "",
			verbose: true
		)
		.fetchImage(processResponse)

	}
	
	
	
	fileprivate func processResponse(_ response: Response) {
		switch response.status {

		case .success:
			Log("Success: \n\(response.body!)")
		case .errorParsingJson, .noInternet, .sessionExpired, .timeout, .unknownError:
			Log("Some kind of error")
			LogError(response.error)
		case .apiError:
			Log("API error")
			LogError(response.error)
		}
        

        
	}
	
}
