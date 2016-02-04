//
//  Dispatch.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 4/2/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//


import Foundation

public func dispatch_background(code: () -> Void) {
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), code)
}

public func dispatch_main(code: () -> Void) {
	dispatch_async(dispatch_get_main_queue(), code)
}

public func dispatch_main_after(seconds: UInt64, code: () -> Void) {
	let popTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(seconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), code);
}