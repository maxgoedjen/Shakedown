//
//  Shakedown.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

@objc class Shakedown {
    
    class func displayFromViewController(viewController: UIViewController) {
        // Explicitly specify bundle for CocoaPods 0.35/0.36 packaging differences
        let storyboard = UIStoryboard(name: "Shakedown", bundle: NSBundle(forClass: ShakedownViewController.self))
        let navController = storyboard.instantiateInitialViewController() as UINavigationController
        viewController.presentViewController(navController, animated: true, completion: nil)
    }
    
    class func beginListeningForShakes() {
        let vc = ShakeTriggerViewController(nibName: nil, bundle: nil) {
            self.displayFromFrontViewController()
        }
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        root?.addChildViewController(vc)
        root?.view.addSubview(vc.view)
    }
    
    class func beginListeningForFiveFingerHold() {
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "fiveFingerHold:")
        gestureRecognizer.numberOfTouchesRequired = 5
        root?.view.addGestureRecognizer(gestureRecognizer)
    }
    
}

// MARK: Configuration

extension Shakedown {

    private struct Configuration {
        static var ReporterInstance: Reporter?
        static var ImageUploaderInstance: ImageUploader = ImgurUploader()
        static var LogUploaderInstance: LogUploader = GistUploader()
        static var ReproducibilityOptions = ["Every Time", "Sometimes", "Rarely"]
        static var AdditionalMetadata: [String : String] = [:]
        static var Log: String = ""
    }

    class var reporter: Reporter? {
        get {
        return Configuration.ReporterInstance
        }
        set {
            Configuration.ReporterInstance = newValue
        }
    }
    
    class var imageUploader: ImageUploader {
        get {
        return Configuration.ImageUploaderInstance
        }
        set {
            Configuration.ImageUploaderInstance = newValue
        }
    }
    
    class var logUploader: LogUploader {
        get {
        return Configuration.LogUploaderInstance
        }
        set {
            Configuration.LogUploaderInstance = newValue
        }
    }

    class var reproducibilityOptions: [String] {
        get {
        return Configuration.ReproducibilityOptions
        }
        set {
            Configuration.ReproducibilityOptions = newValue
        }
    }

    class var additionalMetadata: [String : String] {
        get {
        return Configuration.AdditionalMetadata
        }
        set {
            Configuration.AdditionalMetadata = newValue
        }
    }

    class var log: String {
        get {
        return Configuration.Log
        }
        set {
            Configuration.Log = newValue
        }
    }

}

// MARK: Triggers

extension Shakedown {
    
    class func fiveFingerHold(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            displayFromFrontViewController()
        }
    }
    
    class func displayFromFrontViewController() {
        displayFromViewController(frontViewController)
    }
    
    class var frontViewController: UIViewController {
        let root = UIApplication.sharedApplication().keyWindow!.rootViewController!
        var foremost = root
        while let next = foremost.presentedViewController {
            foremost = next
        }
        return foremost
    }
        
}