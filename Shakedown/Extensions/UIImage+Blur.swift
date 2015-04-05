//
//  UIImage+Blur.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 4/4/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    
    var blurred: UIImage? {
        let ciimage = CoreImage.CIImage(CGImage: CGImage!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter.setValue(ciimage, forKey: kCIInputImageKey)
        filter.setValue(10, forKey: "inputRadius")
        let image = filter.outputImage
        return UIImage(CIImage: image)
    }
    
}