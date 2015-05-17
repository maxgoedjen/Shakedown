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
        case Title, Description, Reproducibility, ReproductionSteps, Screenshot, DeviceLogs, DeviceConfiguration
    }
    
    struct Segues {
        static let ShowLog = "ShowLogSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = report.screenshot.blurred
        let top = navigationController!.navigationBar.frame.height + (UIDevice.currentDevice().userInterfaceIdiom == .Phone ? UIApplication.sharedApplication().statusBarFrame.height : 0)
        collectionView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLog:", name: Shakedown.Notifications.LogUpdated, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let logViewController = segue.destinationViewController as? LogViewController {
            logViewController.report = report
        }
    }
    
    func updateLog(notification: NSNotification) {
        report.deviceLog = Shakedown.configuration.log
        collectionView.reloadSections(NSIndexSet(index: Sections.DeviceLogs.rawValue))
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextFieldCell.identifier, forIndexPath: indexPath) as! TextFieldCell
            cell.textField.text = report.title
            cell.textField.placeholder = NSLocalizedString("What happened?", comment: "Report title placeholder")
            cell.label.text = NSLocalizedString("Report Title", comment: "Report title label")
            configuredCell = cell
        case .Description:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextViewCell.identifier, forIndexPath: indexPath) as! TextViewCell
            cell.textView.text = report.description
            cell.textView.userInteractionEnabled = true
            cell.placeholderLabel.text = NSLocalizedString("What are the details?", comment: "Report Description Placeholder")
            cell.label.text = NSLocalizedString("Details", comment: "Report description label")
            cell.textViewDidChange(cell.textView)
            configuredCell = cell
        case .Reproducibility:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LabelCell.identifier, forIndexPath: indexPath) as! LabelCell
            cell.titleLabel.text = NSLocalizedString("This Happens", comment: "Reproducibility placeholder")
            cell.valueLabel.text = report.reproducibility
            configuredCell = cell
        case .ReproductionSteps:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextFieldCell.identifier, forIndexPath: indexPath) as! TextFieldCell
            if indexPath.row >= report.reproductionSteps.count {
                cell.textField.text = nil
            } else {
                cell.textField.text = report.reproductionSteps[indexPath.item]
                cell.divider.hidden = true
                cell.showLabel(animated: false)
            }
            cell.label.text = NSLocalizedString("Step \(indexPath.item + 1)", comment: "Step number label")
            if report.reproductionSteps.count > 0 {
                cell.textField.placeholder = NSLocalizedString("Step \(indexPath.item + 1)", comment: "Step number label")
            } else {
                cell.textField.placeholder = NSLocalizedString("Steps to Reproduce", comment: "Steps to reproduce placeholder")
            }
            configuredCell = cell
        case .Screenshot:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCell.identifier, forIndexPath: indexPath) as! ImageCell
            cell.imageView.image = report.screenshot
            configuredCell = cell
        case .DeviceLogs:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextViewCell.identifier, forIndexPath: indexPath) as! TextViewCell
            cell.textView.text = abbreviatedLog
            cell.textView.userInteractionEnabled = false
            cell.placeholderLabel.text = nil
            cell.label.text = "Log"
            cell.showLabel(animated: false)
            configuredCell = cell
        case .DeviceConfiguration:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextFieldCell.identifier, forIndexPath: indexPath) as! TextFieldCell
            let title = sorted(report.deviceConfiguration.keys)[indexPath.item]
            cell.label.text = title
            cell.textField.text = report.deviceConfiguration[title]
            cell.textField.enabled = false
            cell.showLabel(animated: false)
            cell.divider.hidden = true
            configuredCell = cell
        }
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
            return CGSize(width: width, height: TextViewCell.heightForText(report.description, width: collectionView.frame.width))
        case .Reproducibility:
            return CGSize(width: width, height: 50)
        case .ReproductionSteps:
            return CGSize(width: width, height: 50)
        case .Screenshot:
            return CGSize(width: width, height: 150)
        case .DeviceLogs:
            return CGSize(width: width, height: TextViewCell.heightForText(abbreviatedLog, width: collectionView.frame.width))
        case .DeviceConfiguration:
            return CGSize(width: width, height: 40)
        }
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
        case .DeviceLogs:
            performSegueWithIdentifier(Segues.ShowLog, sender: nil)
        case .DeviceConfiguration:
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
                collectionView.collectionViewLayout.invalidateLayout()
            case .Reproducibility:
                report.reproducibility = newValue
            case .ReproductionSteps:
                if indexPath.item >= report.reproductionSteps.count {
                    report.reproductionSteps.append(newValue)
                    cell.divider.hidden = true
                    collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: report.reproductionSteps.count, inSection: typed.rawValue)])
                } else {
                    if !newValue.isEmpty {
                        report.reproductionSteps[indexPath.item] = newValue
                        let indexPaths = Array(0...report.reproductionSteps.count).map { NSIndexPath(forItem: $0, inSection: typed.rawValue)}.filter { $0.item != indexPath.row }
                        collectionView.reloadItemsAtIndexPaths(indexPaths)
                    } else {
                        report.reproductionSteps.removeAtIndex(indexPath.item)
                        collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: report.reproductionSteps.count, inSection: typed.rawValue)])
                        collectionView.reloadSections(NSIndexSet(index: indexPath.section))
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
    
    var abbreviatedLog: String {
        let log = report.deviceLog
        if count(log) > 250 {
            return log.substringToIndex(advance(log.startIndex, 250)) + "..."
        }
        return log
    }
    
    class var deviceConfiguration: [String : String] {
        let device = UIDevice.currentDevice()
        var full = [
            "Identifier For Vendor" : device.identifierForVendor.UUIDString,
            "iOS Version": device.systemVersion,
            "Model": device.model,
            "Name": device.name,
            "System Name": device.systemName,
            "App Build": NSBundle.mainBundle().infoDictionary?[kCFBundleVersionKey] as? String ?? "None",
            "App Version": NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? "None"
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