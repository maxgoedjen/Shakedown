//
//  ShakedownViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ShakedownViewController: UIViewController {

    var report = BugReport(
        title: "",
        description: "",
        reproducability: "",
        reproductionSteps: [],
        screenshot: currentScreenImage,
        deviceConfiguration: ShakedownViewController.deviceConfiguration,
        deviceLog: "")
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    enum Sections: Int {
        case Title, Description, Reproducability, ReproductionSteps, Screenshot, DeviceInformation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = report.screenshot
    }
    
}

// PRAGMA MARK: Collection View

extension ShakedownViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let typed = Sections(rawValue: section)!
        switch typed {
        case .ReproductionSteps:
            return report.reproductionSteps.count + 1
        case .DeviceInformation:
            return report.deviceConfiguration.count
        default:
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

// PRAGMA MARK: Buttons

extension ShakedownViewController {
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitReport(sender: UIBarButtonItem) {
        
    }
    
}

// PRAGMA MARK: Configuration

extension ShakedownViewController {
    
    class var deviceConfiguration: [String : String] {
        let device = UIDevice.currentDevice()
        return [
            "Identifier For Vendor" : device.identifierForVendor.UUIDString,
            "iOS Version": device.systemVersion,
            "Model": device.model,
            "Name": device.name,
            "System Name": device.systemName
        ]
    }
    
    class var currentScreenImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, true, 0)
        UIApplication.sharedApplication().keyWindow?.drawViewHierarchyInRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true)
        let captured = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return captured
    }
    
}