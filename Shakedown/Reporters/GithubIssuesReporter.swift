//
//  GithubIssuesReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

struct GithubIssuesReporter: Reporter {
    
    // Generate this token at https://github.com/settings/tokens/new (repo or public_repo scope required)
    let authenticationToken: String
    // Path to project, in the form of "owner/reponame". This project's path would be "maxgoedjen/shakedown"
    let projectPath: String
    
    func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        imageUploader.uploadImage(report.screenshot) {
            screenshotURL, screenshotError in
            logUploader.uploadLog(report.deviceLog, deviceConfiguration: report.deviceConfiguration) {
                logURL, logError in
                if let error = screenshotError ?? logError {
                    completion(completionText: nil, error: error)
                } else {
                    self.uploadReport(report, screenshotURL: screenshotURL, logURL: logURL, completion: completion)
                }
                
            }
        }
    }
    
    func uploadReport(report: BugReport, screenshotURL: NSURL?, logURL: NSURL?, completion: ReportCompletion) {
        let description = issueBody(report, screenshotURL: screenshotURL, logURL: logURL)
        let body = [
            "title" : report.title,
            "body" : description,
        ]
        println("https://api.github.com/repos/\(projectPath)/issues")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/repos/\(projectPath)/issues")!)
        let bodyData = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: nil)
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization" : "token \(authenticationToken)"]
        session.dataTaskWithRequest(request) { data, _, error in
            let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            println(data)
            let urlString = data?["html_url"] as? String ?? ""
            completion(completionText: urlString, error: error)
            }.resume()

    }
    
    func issueBody(report: BugReport, screenshotURL: NSURL?, logURL: NSURL?) -> String {
        var strung = "\n\n\(report.description)\n\n"
        strung += "### Reproducability\n\n\(report.reproducability)\n\n"
        strung += "### Steps to Reproduce\n\n"
        for (index, step) in enumerate(report.reproductionSteps) {
            strung += "\(index). \(step)\n\n"
        }
        if let screenshotURLString = screenshotURL?.absoluteString {
            strung += "### Screenshot\n\n![](\(screenshotURLString))\n\n"
        }
        if let logURLString = logURL?.absoluteString {
            strung += "### Logs\n\n\(logURLString)\n\n"
        }
        return strung
    }
    
}