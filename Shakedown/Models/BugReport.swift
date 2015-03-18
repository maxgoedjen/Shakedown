//
//  BugReport.swift
//  Shakedown
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

@objc class BugReport: DebugPrintable {
    
    var title = ""
    var description = ""
    var reproducability = ""
    var reproductionSteps: [String] = []
    var deviceLog = ""
    var screenshot: UIImage
    var deviceConfiguration: [String : String]
    
    init(screenshot: UIImage, deviceConfiguration: [String : String]) {
        self.screenshot = screenshot
        self.deviceConfiguration = deviceConfiguration
    }
    
    var debugDescription: String {
        return "\(title) \(description)"
    }
    
}