//
//  PivotalReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/21/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

public class PivotalReporter: Reporter {
    
    let authenticationToken: String
    let projectID: String
    
    /**
    
    - parameter authenticationToken: Issues will show as being created by the creator of the token, so you may wish to create an "API User" account to generate the token. If you submit a build to the App Store with this token included, people may be able to extract it, so _MAKE SURE_ the account is limited.
    - parameter projectID:           Pivotal project ID (get from the URL of your project, not the project's name).
    
    - returns: Pivotal Reporter
    */
    public init(authenticationToken: String, projectID: String) {
        self.authenticationToken = authenticationToken
        self.projectID = projectID
        super.init()
    }
    
    
    override internal func fileBugReport(report: BugReport, screenshotURL: NSURL, logURL: NSURL, completion: ReportCompletion) {
        let description = issueBody(report, screenshotURL: screenshotURL, logURL: logURL)
        let fields = [
            "story_type": "bug",
            "name": report.title,
            "description": description
        ]
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.pivotaltracker.com/services/v5/projects/\(projectID)/stories")!)
        let bodyData = try? NSJSONSerialization.dataWithJSONObject(fields, options: [])
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = [
            "X-TrackerToken" : authenticationToken,
            "Content-Type": "application/json"
        ]
        session.dataTaskWithRequest(request) { data, response, error in
            let data = try? NSJSONSerialization.JSONObjectWithOptionalData(data, options: [])
            let id = data?["id"] as? Int
            let idString = id?.description ?? ""
            completion(completionText: idString, error: error ?? response?.httpError)
            }.resume()
        
    }
    
    private func issueBody(report: BugReport, screenshotURL: NSURL, logURL: NSURL) -> String {
        var strung = "\(report.description)\n\n"
        strung += "**Reproducibility**:\n \(report.reproducibility)\n\n"
        if report.reproductionSteps.count > 0 {
            strung += "**Steps to Reproduce:**\n"
            for (index, step) in report.reproductionSteps.enumerate() {
                strung += "\(index+1). \(step)\n"
            }
        }
        strung += "\n"
        strung += "**Screenshot:**\n ![](\(screenshotURL.absoluteString))\n\n"
        strung += "**Logs:**\n \(logURL.absoluteString)\n\n"
        return strung
    }
    
}