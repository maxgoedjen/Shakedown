//
//  NoOpImageUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit
import ShakedownSample

class NoOpSuccessImageUploader: ImageUploader {
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
        completion(url: NSURL(string: "http://imgur.com/asdf"), error: nil)
    }
}

class NoOpFailureImageUploader: ImageUploader {
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
        completion(url: nil, error: NSError(domain: "NoOpFailure", code: 500, userInfo: nil))
    }
}
