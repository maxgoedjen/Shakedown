//
//  Configuration.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/21/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation

@objc class Configuration {
    
    var reporterInstance: Reporter?
    var imageUploaderInstance: ImageUploader = ImgurUploader()
    var logUploaderInstance: LogUploader = GistUploader()
    var reproducibilityOptions = ["Every Time", "Sometimes", "Rarely"]
    var additionalMetadata: [String : String] = [:]
    var log: String = ""
    
    init() {
    }

}
