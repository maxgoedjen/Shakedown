//
//  HeaderView.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/19/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet var label: UILabel!
    
    class var identifier: String {
        return "HeaderView"
    }

}