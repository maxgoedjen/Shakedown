//
//  ImgurUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

struct ImgurUploader: ImageUploader {
    
    let clientID: String
    
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.imgur.com/3/image")!)
        request.allHTTPHeaderFields = ["Authorization" : "Client-ID \(clientID)"]
        request.HTTPMethod = "POST"
        let imageData = UIImagePNGRepresentation(image)
        session.uploadTaskWithRequest(request, fromData: imageData) { data, _, error in
            let data = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            let imgurData = data?["data"] as? [String : AnyObject]
            let urlString = imgurData?["link"] as? String ?? ""
            completion(url: NSURL(string: urlString), error: error)
        }.resume()
    }

}