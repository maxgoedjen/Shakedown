//
//  Shakedown.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

@objc public class Shakedown {
    
    /**
    Show Shakedown programatically from a specific view controller
    
    :param: viewController View controller to present from. If nil, Shakedown shows from front-most view controller.
    */
    public class func displayFrom(viewController: UIViewController? = nil) {
        // Explicitly specify bundle for CocoaPods 0.35/0.36 packaging differences
        let storyboard = UIStoryboard(name: "Shakedown", bundle: NSBundle(forClass: ShakedownViewController.self))
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let presenter = viewController ?? frontViewController
        presenter.presentViewController(navController, animated: true, completion: nil)
    }
    
    /**
    Begin listening for "Shake" trigger. If the user shakes their device, Shakedown will show from the front-most view controller.
    You may want to use `beginListeningForFiveFingerHold` if your app uses shaking to trigger another event (like undo)
    */
    public class func beginListeningForShakes() {
        let vc = ShakeTriggerViewController(nibName: nil, bundle: nil) {
            self.displayFromFrontViewController()
        }
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        root?.addChildViewController(vc)
        root?.view.addSubview(vc.view)
    }
    
    /**
    Begin listening for "5 finger tap and hold" trigger. If user places 5 fingers on the screen and holds it for a second, Shakedown will show from the front-most view controller.
    This is an appropriate trigger to use if you use shake to undo in your app.
    */
    public class func beginListeningForFiveFingerHold() {
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "fiveFingerHold:")
        gestureRecognizer.numberOfTouchesRequired = 5
        root?.view.addGestureRecognizer(gestureRecognizer)
    }
    
    /**
    Append a message to Shakedown's log. Shakedown will take care of newlines/etc for you.
    */
    public class func logMessage(message: String) {
        configuration.log += (message + "\n")
    }
    
}

// MARK: Configuration

extension Shakedown {

    private struct ConfigurationStorage {
        static let ConfigurationInstance = Configuration()
    }

    public class var configuration: Configuration {
        return ConfigurationStorage.ConfigurationInstance
    }

}

// MARK: Triggers

extension Shakedown {
    
    public class func fiveFingerHold(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            displayFromFrontViewController()
        }
    }
    
    private class func displayFromFrontViewController() {
        displayFrom(viewController: frontViewController)
    }
    
    private class var frontViewController: UIViewController {
        let root = UIApplication.sharedApplication().keyWindow!.rootViewController!
        var foremost = root
        while let next = foremost.presentedViewController {
            foremost = next
        }
        return foremost
    }
        
}