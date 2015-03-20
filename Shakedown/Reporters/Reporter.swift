//
//  Reporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

typealias ImageAndLogCompletion = ((imageURL: NSURL?, logURL: NSURL?, error: NSError?) -> Void)
typealias ReportCompletion = ((completionText: String?, error: NSError?) -> Void)

class Reporter {
    
    func uploadImagesAndLogs(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ImageAndLogCompletion) {
        imageUploader.uploadImage(report.screenshot) {
            screenshotURL, screenshotError in
            logUploader.uploadLog(report.deviceLog, deviceConfiguration: report.deviceConfiguration) {
                logURL, logError in
                if let error = screenshotError ?? logError {
                    completion(imageURL: nil, logURL: nil, error: error)
                } else {
                    completion(imageURL: screenshotURL, logURL: logURL, error: nil)
                }
                
            }
        }
    }
    
    func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        
    }
    
}