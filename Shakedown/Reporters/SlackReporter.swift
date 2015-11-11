//
//  SlackReporter.swift
//  Shakedown
//
//  Created by Max Goedjen on 11/11/15.
//  Copyright © 2015 Max Goedjen. All rights reserved.
//

import Foundation

public struct SlackReporter: Reporter {
    
    let webhookURL: String
    
    /**
     
     - parameter webhookURL: Generate this URL at https://YOUR_DOMAIN.slack.com/services/new/incoming-webhook and initialize with the URL they provide.
        It'll look something like this https://hooks.slack.com/services/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
     - returns: Slack Reporter
     */
    public init(webhookURL: String) {
        self.webhookURL = webhookURL
    }
    
    public func fileBugReport(report: BugReport, screenshotURL: NSURL, logURL: NSURL, completion: ReportCompletion) {
        let body = issueBody(report, screenshotURL: screenshotURL, logURL: logURL)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: webhookURL)!)
        let bodyData = try? NSJSONSerialization.dataWithJSONObject(body, options: [])
        request.HTTPBody = bodyData
        request.HTTPMethod = "POST"
        session.dataTaskWithRequest(request) { data, response, error in
            completion(completionText: "Posted", error: error ?? response?.httpError)
            }.resume()
        
    }
    
    private func issueBody(report: BugReport, screenshotURL: NSURL, logURL: NSURL) -> [String: AnyObject] {
        var reproSteps: String
        if report.reproductionSteps.count > 0 {
            reproSteps = ""
            for (index, step) in report.reproductionSteps.enumerate() {
                reproSteps += "\(index+1). \(step)\n"
            }
        } else {
            reproSteps = "None"
        }

        let payload: [String: AnyObject] = [
            "attachments": [[
                "fallback": report.description,
                "pre_text": "New issue reported",
                "text": report.description,
                "title": report.title,
                "color": "warning",
                "image_url": screenshotURL.absoluteString,
                "fields": [
                    [
                        "title": "Reproducability",
                        "value": report.reproducibility,
                        "short": true
                    ],
                    [
                        "title": "Logs",
                        "value": logURL.absoluteString,
                        "short": true
                    ],
                    [
                        "title": "Steps to Reproduce",
                        "value": reproSteps,
                        "short": false
                    ]
                ]
            ]]
        ]
        return payload
    }
    
}