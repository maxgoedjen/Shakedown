//
//  ImageUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

typealias ImageUploadCompletion = (url: NSURL?, error: NSError?) -> Void

protocol ImageUploader {
    func uploadImage(image: UIImage, completion: ImageUploadCompletion)
}