//
//  BugReport.swift
//  Shakedown
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

@objc class BugReport {
    
    var title = ""
    var description = ""
    var reproducability = ""
    var reproductionSteps: [String] = []
    var deviceLog: String
    var screenshot: UIImage
    var deviceConfiguration: [String : String]
    
    init(screenshot: UIImage, deviceConfiguration: [String : String], deviceLog: String?) {
        self.screenshot = screenshot
        self.deviceConfiguration = deviceConfiguration
        self.deviceLog = deviceLog ?? ""
        self.reproducability = Shakedown.reproducabilityOptions.first!
    }
    
}