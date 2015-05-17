//
//  ViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
//        Shakedown.configuration.reporter = nil
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "logMessage:", userInfo: nil, repeats: true)
        Shakedown.logMessage("Test")
        Shakedown.configuration.additionalMetadata = ["Username" : "TestUser"]
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            Shakedown.displayFrom(viewController: self)
        }
    }
    
    func logMessage(timer: NSTimer) {
        let number = arc4random_uniform(1000)
        Shakedown.logMessage("Test \(number)")
    }

}

