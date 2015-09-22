//
//  NSJSONSerialization+Swift.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 9/22/15.
//  Copyright © 2015 Max Goedjen. All rights reserved.
//

import Foundation

extension NSJSONSerialization {
    
    enum NSJSONSerializationSwiftError: ErrorType {
        case NilObject
        case JSONDictionaryCast
    }
    
    public class func JSONObjectWithOptionalData(data: NSData?, options opt: NSJSONReadingOptions = []) throws -> [String: AnyObject] {
        guard let data = data else { throw NSJSONSerializationSwiftError.NilObject }
        do {
            let parsed = try JSONObjectWithData(data, options: opt)
            guard let cast = parsed as? [String: AnyObject] else { throw NSJSONSerializationSwiftError.JSONDictionaryCast }
            return cast
        } catch {
            throw error
        }
    }
    
}