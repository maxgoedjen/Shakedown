//
//  ImageUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/24/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import XCTest
import CoreGraphics
import Quick
import Nimble
import ShakedownSample

class ImageUploaderTests: QuickSpec {
    
    override func spec() {
        // Noop for super class, subclasses do not receive
        if self.isMemberOfClass(ImageUploaderTests) {
            return
        }
        describe("instance uploader") {
            let instance = self.uploader
            it("is initialized properly") {
                expect(instance).toNot(beNil())
            }
            var url: NSURL?
            let sourceImage = self.screenshot
            it("should upload successfully") {
                var error: NSError?
                instance.uploadImage(sourceImage) { (url, error) = ($0, $1) }
                expect(url).toEventuallyNot(beNil(), timeout: 3)
                expect(error).toEventually(beNil(), timeout: 3)
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
    
    var uploader: ImageUploader {
        return NoOpImageUploader()
    }
    
}

class NoOpImageUploader: ImageUploader {
    
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
    }
    
}
