//
//  TestData.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit


struct TestData {
    
    static var log: String {
        return "Something happened\nSomething else happened\nA final thing happened"
    }
    
    static var deviceInfo: [String : String] {
        return ["Device": "iPhone 6", "Device Name": "Max's iPhone"]
    }
    
    static var image: UIImage {
        class TestBundleClass {}
        let path = NSBundle(forClass: TestBundleClass.self).pathForResource("TestImage", ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }
    
}