//
//  GithubIssuesReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

class GithubIssuesReporter: Reporter {
    
    // Generate this token at https://github.com/settings/tokens/new (repo or public_repo scope required)
    // Issues will show as being created by the creator of the token, so you may wish to create an "API User" account to generate the token
    // If you submit a build to the App Store with this token included, people may be able to extract it, so _MAKE SURE_ the account is limited
    // People stealing your GitHub token and getting access to your repos is no fun. 🔥
    let authenticationToken: String
    // Path to project, in the form of "owner/reponame". This project's path would be "maxgoedjen/shakedown"
    let projectPath: String
    
    init(authenticationToken: String, projectPath: String) {
        self.authenticationToken = authenticationToken
        self.projectPath = projectPath
        super.init()
    }
    
    override func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        uploadImagesAndLogs(report, imageUploader: imageUploader, logUploader: logUploader) { screenshotURL, logURL, error in
            if error ==  nil {
                self.uploadReport(report, screenshotURL: screenshotURL, logURL: logURL, completion: completion)
            } else {
                completion(completionText: nil, error: error)
            }
        }
    }
    
    func uploadReport(report: BugReport, screenshotURL: NSURL?, logURL: NSURL?, completion: ReportCompletion) {
        let description = issueBody(report, screenshotURL: screenshotURL, logURL: logURL)
        let body = [
            "title" : report.title,
            "body" : description,
        ]
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/repos/\(projectPath)/issues")!)
        let bodyData = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: nil)
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization" : "token \(authenticationToken)"]
        session.dataTaskWithRequest(request) { data, _, error in
            let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            let urlString = data?["html_url"] as? String ?? ""
            completion(completionText: urlString, error: error)
            }.resume()

    }
    
    func issueBody(report: BugReport, screenshotURL: NSURL?, logURL: NSURL?) -> String {
        var strung = "\n\n\(report.description)\n\n"
        strung += "### reproducibility\n\n\(report.reproducibility)\n\n"
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