//
//  FileUploaderTests.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/26/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import Foundation
import Mockingjay

protocol UploaderTest {
    var expectedURL: NSURL { get }
    func stubAndVerifyRequest(request: NSURLRequest) -> Response
}