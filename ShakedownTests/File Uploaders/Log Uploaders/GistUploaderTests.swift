//
//  GistUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/23/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import XCTest
import Quick
import Nimble
import ShakedownSample

class GistUploaderTests: LogUploaderTests {
    
    override var uploader: LogUploader {
        return GistUploader(authenticationToken: "TestToken")
    }
    
}
