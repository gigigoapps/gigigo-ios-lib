//
//  Result.swift
//  GIGLibrary
//
//  Created by Alejandro Jiménez Agudo on 19/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

public enum Result<SuccessType, ErrorType> {
	
	case success(SuccessType)
	case error(ErrorType)
	
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .error:
            return false
        }
    }
    
    public var isError: Bool {
        return !isSuccess
    }
    
    public var value: SuccessType? {
        switch self {
        case .success(let value):
            return value
        case .error:
            return nil
        }
    }
    
    public var error: ErrorType? {
        switch self {
        case .success:
            return nil
        case .error(let error):
            return error
        }
    }
}
