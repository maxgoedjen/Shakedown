//
//  JIRAReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/20/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

struct JIRAReporter: Reporter {

    // Generate this token at
    // Issues will show as being created by the creator of the token, so you may wish to create an "API User" account to generate the token
    // If you submit a build to the App Store with this token included, people may be able to extract it, so _MAKE SURE_ the account is limited
    let authenticationToken: String
    // JIRA Project key. This is the prefix before the ticket number, i.e. if had ticket MG-300, your project key would be MG
    let projectKey: String

    func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        
    }

}