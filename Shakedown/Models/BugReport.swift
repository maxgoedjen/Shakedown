//
//  BugReport.swift
//  Shakedown
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

struct BugReport {
    let title: String
    let description: String
    let reproducability: String
    let reproductionSteps: [String]
    let screenshot: UIImage
    let deviceConfiguration: [String : String]
    let deviceLog: String
}