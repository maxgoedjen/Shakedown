//
//  ImageUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/24/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Mockingjay
import ShakedownSample

class ImageUploaderTests: QuickSpec, UploaderTest {
    
    override func spec() {
        // Noop for super class, subclasses do not receive
        if self.isMemberOfClass(ImageUploaderTests) {
            return
        }

        describe("uploader") {
            let instance = self.uploader
            it("is initialized properly") {
                expect(instance).toNot(beNil())
            }
            let sourceImage = self.screenshot
            it("should upload successfully") {
                var url: NSURL?
                var error: NSError?
                self.stub(everything, self.stubAndVerifyRequest)
                instance.uploadImage(sourceImage) { (url, error) = ($0, $1) }
                expect(url).toEventually(equal(self.expectedURL), timeout: 3)
                expect(error).toEventually(beNil(), timeout: 3)
            }
            it("should report an error if server returns an error") {
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
    
    var expectedURL: NSURL {
        return NSURL()
    }
    
    var screenshot: UIImage {
        let path = NSBundle(forClass: ImageUploaderTests.self).pathForResource("TestImage", ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }
    
    var uploader: ImageUploader {
        return NoOpImageUploader()
    }
    
}

class NoOpImageUploader: ImageUploader {
    
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
    }
    
}
