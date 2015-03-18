//
//  Reporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

typealias ReportCompletion = ((completionText: String?, error: String?) -> Void)

protocol Reporter {
    func fileBugReport(report: BugReport, completion: ReportCompletion)
}