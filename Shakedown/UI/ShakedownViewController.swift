//
//  ShakedownViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ShakedownViewController: UIViewController {

    let screenshot: UIImage
    var report = BugReport(title: "", description: "", reproducability: "", reproductionSteps: [], screenshot: UIImage(), deviceConfiguration: [:], deviceLog: "")
    
    enum Sections: Int {
        case Title, Description, Reproducability, ReproductionSteps, Screenshot, DeviceInformation
    }

    init(screenshot: UIImage) {
        self.screenshot = screenshot
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Please initialize from init(screenshot:)")
    }
    
}
