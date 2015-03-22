//
//  ImageUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

public typealias ImageUploadCompletion = (url: NSURL?, error: NSError?) -> Void

public protocol ImageUploader {
    
     func uploadImage(image: UIImage, completion: ImageUploadCompletion)
    
}