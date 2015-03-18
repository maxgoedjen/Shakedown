//
//  ShakedownViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ShakedownViewController: UIViewController {

    var report = BugReport(screenshot: currentScreenImage, deviceConfiguration: ShakedownViewController.deviceConfiguration, deviceLog: Shakedown.log)
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
        var identifier: String!
        switch typed {
        case .Title:
            identifier = TextFieldCell.identifier
        case .Description:
            identifier = TextViewCell.identifier
        case .Reproducability:
            identifier = TextFieldCell.identifier
        case .ReproductionSteps:
            identifier = TextFieldCell.identifier
        case .Screenshot:
            identifier = TextFieldCell.identifier
        case .DeviceConfiguration:
            identifier = TextFieldCell.identifier
        case .DeviceLogs:
            identifier = TextFieldCell.identifier
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as ShakedownCell
        cell.backgroundColor = indexPath.section % 2 == 0 ? UIColor.grayColor() : UIColor.lightGrayColor()
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let typed = Sections(rawValue: indexPath.section)!
        let width = collectionView.frame.size.width
        switch typed {
        case .Title:
            return CGSize(width: width, height: 30)
        case .Description:
            return CGSize(width: width, height: 100)
        case .Reproducability:
            return CGSize(width: width, height: 30)
        case .ReproductionSteps:
            return CGSize(width: width, height: 30)
        case .Screenshot:
            return CGSize(width: width, height: 150)
        case .DeviceConfiguration:
            return CGSize(width: width, height: 10)
        case .DeviceLogs:
            return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let typed = Sections(rawValue: indexPath.section)!
        switch typed {
        case .Reproducability:
            break
        case .ReproductionSteps:
            break
        case .Screenshot:
            break
        case .DeviceConfiguration:
            break
        case .DeviceLogs:
            break
        default:
            break
        }
    }
    
}

// Mark: Cell Delegate

extension ShakedownViewController: ShakedownCellDelegate {
    
    func cell(cell: ShakedownCell, valueChanged newValue: String) {
        if let indexPath = collectionView.indexPathForCell(cell) {
            let typed = Sections(rawValue: indexPath.section)!
            switch typed {
            case .Title:
                report.title = newValue
            case .Description:
                report.description = newValue
            case .Reproducability:
                report.reproducability = newValue
            case .ReproductionSteps:
                if indexPath.item >= report.reproductionSteps.count {
                    report.reproductionSteps.append(newValue)
                } else {
                    report.reproductionSteps[indexPath.item] = newValue
                }
            default:
                // No-op for logs, device config, screenshot
                break
            }
        }
        println(report)
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