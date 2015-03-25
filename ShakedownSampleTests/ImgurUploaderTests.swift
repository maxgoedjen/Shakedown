//
//  ImgurUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/23/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import XCTest
import CoreGraphics
import Quick
import Nimble
import Mockingjay
import ShakedownSample

class ImgurUploaderTests: ImageUploaderTests {

    override var uploader: ImageUploader {
        return ImgurUploader()
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        let response = NSHTTPURLResponse(URL: request.URL, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, nil)
    }
    
}
