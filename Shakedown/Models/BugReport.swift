//
//  BugReport.swift
//  Shakedown
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

@objc public class BugReport {
    
    var title = ""
    var description = ""
    var reproducibility = ""
    var reproductionSteps: [String] = []
    var deviceLog: String
    var screenshot: UIImage
    var deviceConfiguration: [String : String]
    
    public init(screenshot: UIImage, deviceConfiguration: [String : String], deviceLog: String?) {
        self.screenshot = screenshot
        self.deviceConfiguration = deviceConfiguration
        self.deviceLog = deviceLog ?? ""
        self.reproducibility = Shakedown.configuration.reproducibilityOptions.first!
    }
    
}