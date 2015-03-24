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

class ImgurUploaderTests: QuickSpec {
    
    override func spec() {
        describe("Imgur uploader") {
            let imgur = ImgurUploader()
            it("is initialized properly") {
                expect(imgur).toNot(beNil())
            }
            var url: NSURL?
            let sourceImage = self.screenshot
            it("should upload successfully") {
                var error: NSError?
                imgur.uploadImage(sourceImage) { (url, error) = ($0, $1) }
                expect(url).toEventuallyNot(beNil(), timeout: 10)
                expect(error).toEventually(beNil(), timeout: 10)
            }
            it("should have uploaded a valid image") {
                var data: NSData?
                var error: NSError?
                NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, _, error) = ($0, $1, $2) }.resume()
                expect(data).toEventuallyNot(beNil(), timeout: 3)
                expect(error).toEventually(beNil(), timeout: 3)
                let image = UIImage(data: data!)
                expect(UIImagePNGRepresentation(image)) == UIImagePNGRepresentation(sourceImage)
            }
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
