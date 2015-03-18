//
//  Reporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

typealias ReportCompletion = ((completionText: String?, error: NSError?) -> Void)

protocol Reporter {
    func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion)
}