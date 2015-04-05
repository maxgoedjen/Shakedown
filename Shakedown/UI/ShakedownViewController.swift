//
//  ShakedownViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ShakedownViewController: UIViewController {

    var report = BugReport(screenshot: currentScreenImage, deviceConfiguration: ShakedownViewController.deviceConfiguration, deviceLog: Shakedown.configuration.log)
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    enum Sections: Int {
        case Title, Description, Reproducibility, ReproductionSteps, Screenshot, DeviceConfiguration, DeviceLogs
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        backgroundImageView.image = report.screenshot.blurred
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
        var configuredCell: ShakedownCell!
        var identifier: String!
        switch typed {
        case .Title:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextFieldCell.identifier, forIndexPath: indexPath) as TextFieldCell
            cell.textField.text = report.title
            cell.textField.placeholder = NSLocalizedString("Report Title", comment: "Report Title Placeholder")
            configuredCell = cell
        case .Description:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextViewCell.identifier, forIndexPath: indexPath) as TextViewCell
            cell.textView.text = report.description
            cell.textView.userInteractionEnabled = true
            configuredCell = cell
        case .Reproducibility:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LabelCell.identifier, forIndexPath: indexPath) as LabelCell
            cell.titleLabel.text = NSLocalizedString("This Happens", comment: "Reproducibility Prefix")
            cell.valueLabel.text = report.reproducibility
            configuredCell = cell
        case .ReproductionSteps:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextFieldCell.identifier, forIndexPath: indexPath) as TextFieldCell
            if indexPath.row >= report.reproductionSteps.count {
                cell.textField.text = nil
            } else {
                cell.textField.text = report.reproductionSteps[indexPath.item]
            }
            configuredCell = cell
        case .Screenshot:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCell.identifier, forIndexPath: indexPath) as ImageCell
            cell.imageView.image = report.screenshot
            configuredCell = cell
        case .DeviceConfiguration:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LabelCell.identifier, forIndexPath: indexPath) as LabelCell
            let title = sorted(report.deviceConfiguration.keys)[indexPath.item]
            cell.titleLabel.text = title
            cell.valueLabel.text = report.deviceConfiguration[title]
            configuredCell = cell
        case .DeviceLogs:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextViewCell.identifier, forIndexPath: indexPath) as TextViewCell
            cell.textView.text = report.deviceLog
            cell.textView.userInteractionEnabled = false
            configuredCell = cell
        }
        configuredCell.backgroundColor = indexPath.section % 2 == 0 ? UIColor.grayColor() : UIColor.lightGrayColor()
        configuredCell.delegate = self
        return configuredCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let typed = Sections(rawValue: indexPath.section)!
        let width = collectionView.frame.size.width
        switch typed {
        case .Title:
            return CGSize(width: width, height: 50)
        case .Description:
            return CGSize(width: width, height: 100)
        case .Reproducibility:
            return CGSize(width: width, height: 50)
        case .ReproductionSteps:
            return CGSize(width: width, height: 40)
        case .Screenshot:
            return CGSize(width: width, height: 150)
        case .DeviceConfiguration:
            return CGSize(width: width, height: 20)
        case .DeviceLogs:
            return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let typed = Sections(rawValue: section)!
        switch typed {
        case .ReproductionSteps:
            return CGSize(width: collectionView.frame.size.width, height: 20)
        default:
            return CGSizeZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let typed = Sections(rawValue: indexPath.section)!
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HeaderView.identifier, forIndexPath: indexPath) as HeaderView
        switch typed {
        case .ReproductionSteps:
            header.label.text = NSLocalizedString("Steps to Reproduce", comment: "Steps to Reproduce Section Header")
        default:
            break
        }
        return header
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let typed = Sections(rawValue: indexPath.section)!
        switch typed {
        case .Reproducibility:
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
            case .Reproducibility:
                report.reproducibility = newValue
            case .ReproductionSteps:
                if indexPath.item >= report.reproductionSteps.count {
                    report.reproductionSteps.append(newValue)
                    collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: report.reproductionSteps.count, inSection: typed.rawValue)])
                } else {
                    if !newValue.isEmpty {
                        report.reproductionSteps[indexPath.item] = newValue
                    } else {
                        report.reproductionSteps.removeAtIndex(indexPath.item)
                        collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: report.reproductionSteps.count, inSection: typed.rawValue)])
                    }
                }
            default:
                // No-op for logs, device config, screenshot
                break
            }
        }
    }
    
}

// MARK: Buttons

extension ShakedownViewController {
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitReport(sender: UIBarButtonItem) {
        Shakedown.configuration.reporter?.fileBugReport(report, imageUploader: Shakedown.configuration.imageUploader, logUploader: Shakedown.configuration.logUploader) { message in
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
        for (key, value) in Shakedown.configuration.additionalMetadata {
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