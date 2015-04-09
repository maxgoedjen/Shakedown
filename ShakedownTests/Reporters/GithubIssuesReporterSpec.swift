//
//  GithubIssuesReporterSpec.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation
import Nimble
import ShakedownSample
import Mockingjay

class GithubIssuesReporterSpec: ReporterSpec {
    
    override var reporter: Reporter {
        return GithubIssuesReporter(authenticationToken: "TestToken", projectPath: "maxgoedjen/Shakedown")
    }
    
    override var expectedMessage: String {
        return "#9"
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        expect(request.URL!.absoluteString) == "https://api.github.com/repos/maxgoedjen/Shakedown/issues"
        expect(request.valueForHTTPHeaderField("Authorization")) == "token TestToken"
        let data = request.HTTPBody ?? request.HTTPBodyStream?.synchronouslyRead()
        let parsedJSON: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil)!
        expect(parsedJSON.description) == jsonObject("GithubIssuesRequest").description
        expect(request.HTTPMethod) == "POST"
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 201, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, jsonData("GithubIssuesResponse"))
    }

}