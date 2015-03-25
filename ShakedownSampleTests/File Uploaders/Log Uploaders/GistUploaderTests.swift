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

class GistUploaderTests: QuickSpec {
    
    override func spec() {
        describe("Imgur uploader") {
        }
    }
    
    var screenshot: UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 300, height: 300))
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addLineToPoint(CGPointMake(300, 300))
        path.stroke()
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
