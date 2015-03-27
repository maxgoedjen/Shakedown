//
//  PivotalReporterSpec.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation
import Nimble
import ShakedownSample
import Mockingjay

class PivotalReporterSpec: ReporterSpec {
    
    override var reporter: Reporter {
        return PivotalReporter(authenticationToken: "Test", projectID: "Test")
    }
    
    override var expectedMessage: String {
        return "ST-19"
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        expect(request.URL.absoluteString) == "https://maxgoedjen-shakedown.atlassian.net/rest/api/2/issue/"
        expect(request.valueForHTTPHeaderField("Authorization")) == "Basic bWF4OnBhc3N3b3Jk"
        expect(request.valueForHTTPHeaderField("Content-Type")) == "application/json"
        let data = request.HTTPBody ?? request.HTTPBodyStream?.synchronouslyRead()
        let parsedJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)!
        expect(parsedJSON.description) == jsonObject("PivotalRequest").description
        expect(request.HTTPMethod) == "POST"
        let response = NSHTTPURLResponse(URL: request.URL, statusCode: 201, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, jsonData("PivotalResponse"))
    }
    
}