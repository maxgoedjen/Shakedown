//
//  GithubIssuesReporterSpec.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation
import ShakedownSample
import Mockingjay

class GithubIssuesReporterSpec: ReporterSpec {
    
    override var reporter: Reporter {
        return GithubIssuesReporter(authenticationToken: "TestToken", projectPath: "maxgoedjen/Shakedown")
    }
    
    override var expectedMessage: String {
        return "#42"
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        let response = NSHTTPURLResponse(URL: request.URL, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, jsonData("Imgur"))
    }

}