//
//  LogUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

typealias LogUploadCompletion = (url: NSURL?, error: NSError?) -> Void

protocol LogUploader {
    func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion)
}