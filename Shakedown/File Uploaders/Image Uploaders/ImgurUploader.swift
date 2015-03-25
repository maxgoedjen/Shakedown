//
//  ImgurUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

public struct ImgurUploader: ImageUploader {
    
    // Shared Client ID for all of Shakedown for out of the box support.
    // Can be overwritten by replacing Shakedown's image uploader with one with your own ID
    let clientID: String
    
    public init(clientID: String = "bda77c3163be215") {
        self.clientID = clientID
    }
    
    public func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.imgur.com/3/image")!)
        request.allHTTPHeaderFields = ["Authorization" : "Client-ID \(clientID)"]
        request.HTTPMethod = "POST"
        let imageData = UIImagePNGRepresentation(image)
        session.uploadTaskWithRequest(request, fromData: imageData) { data, response, error in
            println(response)
            let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            let imgurData = data?["data"] as? [String : AnyObject]
            let urlString = imgurData?["link"] as? String ?? ""
            completion(url: NSURL(string: urlString), error: error)
        }.resume()
    }

}