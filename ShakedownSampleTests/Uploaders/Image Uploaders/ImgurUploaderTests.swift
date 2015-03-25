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
import ShakedownSample

class ImgurUploaderTests: ImageUploaderTests {

    override var uploader: ImageUploader {
        return ImgurUploader()
    }
    
}
