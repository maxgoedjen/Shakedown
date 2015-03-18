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
    
    @IBOutlet var collectionView: UICollectionView!
    
    enum Sections: Int {
        case Title, Description, Reproducability, ReproductionSteps, Screenshot, DeviceConfiguration, DeviceLogs
    }
    
}

// MARK: Collection View

extension ShakedownViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let typed = Sections(rawValue: section)!
        switch typed {
        case .ReproductionSteps:
            return report.reproductionSteps.count + 1
        case .DeviceConfiguration:
            return report.deviceConfiguration.count
        default:
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let typed = Sections(rawValue: indexPath.section)!
        var cell: UICollectionViewCell!
        switch typed {
        case .Title:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        case .Description:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        case .Reproducability:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        case .ReproductionSteps:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        case .Screenshot:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        case .DeviceConfiguration:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        case .DeviceLogs:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextFieldCell", forIndexPath: indexPath) as UICollectionViewCell
        }
        cell?.backgroundColor = indexPath.section % 2 == 0 ? UIColor.grayColor() : UIColor.lightGrayColor()
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
    
}

// MARK: Buttons

extension ShakedownViewController {
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitReport(sender: UIBarButtonItem) {
        Shakedown.reporter?.fileBugReport(report, imageUploader: Shakedown.imageUploader, logUploader: Shakedown.logUploader) { message in
            println(message)
        }
    }
    
}

// MARK: Configuration

extension ShakedownViewController {
    
    class var deviceConfiguration: [String : String] {
        let device = UIDevice.currentDevice()
        var full = [
            "Identifier For Vendor" : device.identifierForVendor.UUIDString,
            "iOS Version": device.systemVersion,
            "Model": device.model,
            "Name": device.name,
            "System Name": device.systemName
        ]
        for (key, value) in Shakedown.additionalMetadata {
            full[key] = value
        }
        return full
    }
    
    class var currentScreenImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, true, 0)
        UIApplication.sharedApplication().keyWindow?.drawViewHierarchyInRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true)
        let captured = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return captured
    }
    
}