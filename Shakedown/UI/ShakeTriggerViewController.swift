//
//  ShakeTriggerViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/21/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

/**
*  Invisible view/view controller that observes shake events
*/
class ShakeTriggerViewController: UIViewController {
    
    let trigger: (Void -> Void)
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, trigger: (Void -> Void)) {
        self.trigger = trigger
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.frame = CGRectZero
    }
    
    required init(coder aDecoder: NSCoder) {
        self.trigger = {}
        super.init()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        becomeFirstResponder()
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == .MotionShake {
            trigger()
        }
    }
    
}
