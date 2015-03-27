//
//  JSONStubResponse.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

func jsonObject(name: String) -> AnyObject {
    return NSJSONSerialization.JSONObjectWithData(jsonData(name), options: nil, error: nil)!
}

func jsonData(name: String) -> NSData {
    let path = NSBundle(forClass: ImageUploaderTests.self).URLForResource(name, withExtension: "json")
    return NSData(contentsOfURL: path!)!
}
