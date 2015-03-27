//
//  NSURLResponse+Error.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/25/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

extension NSURLResponse {
    
    var httpError: NSError? {
        if let response = self as? NSHTTPURLResponse {
            if 200..<300 ~= response.statusCode {
                return nil
            } else {
                return NSError(domain: "NSURLHTTPResponseErrorDomain", code: response.statusCode, userInfo: nil)
            }
        }
        return nil
    }
    
}