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
import Mockingjay
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
            let sourceImage = self.screenshot
            it("should upload successfully") {
                var url: NSURL?
                var error: NSError?
//                self.stub(everything, self.stubAndVerifyRequest)
                instance.uploadImage(sourceImage) { (url, error) = ($0, $1) }
                expect(url).toEventuallyNot(beNil(), timeout: 3)
                expect(error).toEventually(beNil(), timeout: 3)
            }
            it("should report an error if server returns a 500") {
                var url: NSURL?
                var error: NSError?
                self.stub(everything, builder: http(status: 500))
                instance.uploadImage(sourceImage) { (url, error) = ($0, $1) }
                expect(url).toEventually(beNil(), timeout: 3)
                expect(error).toEventuallyNot(beNil(), timeout: 3)
            }
        }
    }
    
    func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        let response = NSHTTPURLResponse(URL: request.URL, statusCode: 500, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, nil)
    }
    
    var uploader: ImageUploader {
        return NoOpImageUploader()
    }
    
}

// MARK: Private

extension ImageUploaderTests {
    
    private var screenshot: UIImage {
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

class NoOpImageUploader: ImageUploader {
    
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
    }
    
}
