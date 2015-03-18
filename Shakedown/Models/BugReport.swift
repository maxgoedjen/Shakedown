//
//  BugReport.swift
//  Shakedown
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

private struct BugReport {
    
    let title: String
    let description: String
    let reproducability: String
    let reproductionSteps: [String]
    let screenshot: UIImage
    let deviceInformation: [String : String]
    let deviceLog: String
    let additionalInformation: [String : String]?
    
}