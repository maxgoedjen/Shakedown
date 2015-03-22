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
        Shakedown.logMessage("Test")
        Shakedown.configuration.additionalMetadata = ["A" : "B"]
        Shakedown.displayFrom(viewController: self)
    }

}

