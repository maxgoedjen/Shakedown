//
//  ShakedownViewController.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ShakedownViewController: UIViewController {

    var report: BugReport
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    enum Sections: Int {
        case Title, Description, Reproducability, ReproductionSteps, Screenshot, DeviceInformation
    }

    init(screenshot: UIImage) {
        report = BugReport(title: "", description: "", reproducability: "", reproductionSteps: [], screenshot: screenshot, deviceConfiguration: [:], deviceLog: "")
        // Explicitly specify bundle for CocoaPods 0.35/0.36 packaging differences
        super.init(nibName: "ShakedownViewController", bundle: NSBundle(forClass: ShakedownViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = report.screenshot
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Please initialize from init(screenshot:)")
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
            return deviceConfiguration.count
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
    
    @IBAction func cancel(sender: UIButton) {
        
    }
    
    @IBAction func submitReport(sender: UIButton) {
        
    }
    
}

// PRAGMA MARK: Configuration

extension ShakedownViewController {
    
    var deviceConfiguration: [String : String] {
        let device = UIDevice.currentDevice()
        return [
            "Identifier For Vendor" : device.identifierForVendor.UUIDString,
            "iOS Version": device.systemVersion,
            "Model": device.model,
            "Name": device.name,
            "System Name": device.systemName
        ]
    }
    
}