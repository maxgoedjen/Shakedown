//
//  NoOpLogUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation
import ShakedownSample

class NoOpSuccessLogUploader: LogUploader {
    func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion) {
        completion(url: NSURL(string: "http://gist.github.com/anonymous/asdf"), error: nil)
    }
}

class NoOpFailureLogUploader: LogUploader {
    func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion) {
        completion(url: nil, error: NSError(domain: "NoOpFailure", code: 500, userInfo: nil))
    }
}
