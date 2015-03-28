//
//  ImageCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/18/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class ImageCell: ShakedownCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override class var identifier: String {
        return "ImageCell"
    }

}