//
//  GistUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

public struct GistUploader: LogUploader {
    
    let authenticationToken: String? = nil
    
    public func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion) {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/gists")!)
        let requestBody = ["files": [
            "Configuration.md" : ["content" : formattedConfiguration(deviceConfiguration)],
            "Log.txt" : ["content" : log]
        ]]
        let logData = NSJSONSerialization.dataWithJSONObject(requestBody, options: nil, error: nil)
        request.HTTPBody = logData
        request.HTTPMethod = "POST"
        if let token = authenticationToken {
            request.allHTTPHeaderFields = ["Authorization" : "token \(authenticationToken)"]
        }
        session.dataTaskWithRequest(request) { data, _, error in
            let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            let urlString = data?["html_url"] as? String ?? ""
            completion(url: NSURL(string: urlString), error: error)
            }.resume()
    }
    
    private func formattedConfiguration(configuration: [String : String]) -> String {
        var strung = ""
        for (key, value) in configuration {
            strung += "`\(key)` : `\(value)`\n\n"
        }
        return strung
    }
    
}