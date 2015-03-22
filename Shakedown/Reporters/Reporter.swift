//
//  Reporter.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

public typealias ImageAndLogCompletion = ((imageURL: NSURL?, logURL: NSURL?, error: NSError?) -> Void)
public typealias ReportCompletion = ((completionText: String?, error: NSError?) -> Void)

public class Reporter {
    
    /**
    Convenience function to allow subclasses to upload images and logs in one shot
    
    :param: report        Report to upload images/logs from
    :param: imageUploader ImageUploader subclass
    :param: logUploader   LogUploader subclass
    :param: completion    Completion handler. If either logs or screenshot upload fails, error will be non-nil
    */
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
    
    /**
    File the bug report with the tracker
    
    :param: report        Report to file
    :param: imageUploader ImageUploader subclass, which will be provided as configured in Shakedown.swift
    :param: logUploader   LogUploader subclass, which will be provided as configured in Shakedown.swift
    :param: completion    Completion handler to call when finished. Call with completion text (ticket ID, etc)
    */
    public func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        
    }
    
}