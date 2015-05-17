//
//  ButtonCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/18/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ButtonCell: ShakedownCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    override class var identifier: String {
        return "ButtonCell"
    }

}