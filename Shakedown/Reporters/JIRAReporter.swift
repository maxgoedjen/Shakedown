//
//  JIRAReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/20/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

public struct JIRAReporter: Reporter {

    let instanceURL: String
    let username: String
    let password: String
    let projectKey: String
    let issueType: String
    let reproducibilityField: String?
    
    /**
    
    - parameter instanceURL:          JIRA instance URL. This will be something like https://yourcompany.atlassian.net
    - parameter username:             JIRA Username. Issues will show as being created by this user, so you may wish to create an "API User" account to use
    - parameter password:             JIRA Password. If you submit a build to the App Store with this token included, people may be able to extract it, so _MAKE SURE_ the account is limited
    - parameter projectKey:           JIRA Project key. This is the prefix before the ticket number, i.e. if had ticket MG-300, your project key would be MG
    - parameter issueType:            Issue type to create. If you don't track bugs as "Bug," (like, if everything is a "Task" or something dumb like that) you probably want to change this
    - parameter reproducibilityField: If your project has a specific field for reproducibility, specify it here, otherwise reproducibility will be appended to the description in JIRA
    
    - returns: JIRA Reporter
    */
    public init(instanceURL: String, username: String, password: String, projectKey: String, issueType: String = "Bug", reproducibilityField: String? = nil) {
        self.instanceURL = instanceURL
        self.username = username
        self.password = password
        self.projectKey = projectKey
        self.issueType = issueType
        self.reproducibilityField = reproducibilityField
    }
    
    public func fileBugReport(report: BugReport, screenshotURL: NSURL, logURL: NSURL, completion: ReportCompletion) {
        let description = issueBody(report, screenshotURL: screenshotURL, logURL: logURL)
        var fields: [String : AnyObject] = [ // This is being cast to NSDictionary without explicit type annotation
            "project" : ["key" : self.projectKey],
            "summary": report.title,
            "description": description,
            "issuetype": ["name" : self.issueType]
        ]
        if let reproField = self.reproducibilityField {
            fields[reproField] = ["value": report.reproducibility]
        }
        let body = ["fields": fields]
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "\(instanceURL)/rest/api/2/issue/")!)
        let bodyData = try? NSJSONSerialization.dataWithJSONObject(body, options: [])
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        let authString = "\(username):\(password)"
        let base64Auth = authString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.base64EncodedStringWithOptions([])
        request.allHTTPHeaderFields = [
            "Authorization" : "Basic \(base64Auth!)",
            "Content-Type": "application/json"
        ]
        session.dataTaskWithRequest(request) { data, response, error in
            let data = try? NSJSONSerialization.JSONObjectWithOptionalData(data)
            let id = data?["key"] as? String ?? ""
            completion(completionText: id, error: error ?? response?.httpError)
            }.resume()
        
    }

    private func issueBody(report: BugReport, screenshotURL: NSURL, logURL: NSURL) -> String {
        var strung = "\(report.description)\n\n"
        if reproducibilityField == nil {
            strung += "h4. Reproducibility\n \(report.reproducibility)\n\n"
        }
        if report.reproductionSteps.count > 0 {
            strung += "h4. Steps to Reproduce\n"
            strung += report.reproductionSteps.map { "# \($0)" }.joinWithSeparator("\n")
            strung += "\n\n"
        }
        strung += "h4. Screenshot\n !\(screenshotURL.absoluteString)!\n\n"
        strung += "h4. Logs\n \(logURL.absoluteString)\n\n"
        return strung
    }

}