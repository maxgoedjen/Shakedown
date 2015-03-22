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
        Shakedown.configuration.reporter = nil
        Shakedown.displayFromViewController(viewController: self)
    }

}

