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
    File the bug report with the tracker
    
    :param: report        Report to file
    :param: imageUploader ImageUploader subclass, which will be provided as configured in Shakedown.swift
    :param: logUploader   LogUploader subclass, which will be provided as configured in Shakedown.swift
    :param: completion    Completion handler to call when finished. Call with completion text (ticket ID, etc)
    */
    public func fileBugReport(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ReportCompletion) {
        uploadImagesAndLogs(report, imageUploader: imageUploader, logUploader: logUploader) { screenshotURL, logURL, error in
            if error == nil {
                self.fileBugReport(report, screenshotURL: screenshotURL ?? NSURL(string: "")!, logURL: logURL ?? NSURL(string: "")!, completion: completion)
            } else {
                completion(completionText: nil, error: error)
            }
        }
    }
    
    /**
    File the bug report with the tracker. Subclasses need only override this method.
    
    :param: report        Report to file
    :param: screenshotURL URL to screenshot attachment
    :param: logURL        URL to log attachment
    :param: completion    Completion handler to call when finished. Call with completion text (ticket ID, etc)
    */
    internal func fileBugReport(report: BugReport, screenshotURL: NSURL, logURL: NSURL, completion: ReportCompletion) {
        
    }

    /**
    Convenience function to allow subclasses to upload images and logs in one shot
    
    :param: report        Report to upload images/logs from
    :param: imageUploader ImageUploader subclass
    :param: logUploader   LogUploader subclass
    :param: completion    Completion handler. If either logs or screenshot upload fails, error will be non-nil
    */
    private func uploadImagesAndLogs(report: BugReport, imageUploader: ImageUploader, logUploader: LogUploader, completion: ImageAndLogCompletion) {
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

}