//
//  GithubIssuesReporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

struct GithubIssuesReporter: Reporter {
    
    let authenticationToken: String
    let projectName: String
    
    func fileBugReport(report: BugReport, completion: ReportCompletion) {
        
    }
    
}