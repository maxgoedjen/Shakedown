//
//  ImgurUploader.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/17/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

struct ImgurUploader: ImageUploader {
    
    // Client ID for your Imgur Application
    // Get this from https://api.imgur.com/oauth2/addclient
    // Choose "OAuth2 authorization without a callback URL" and paste in the Client ID you get
    let clientID: String
    
    init(clientID: String?) {
        assert(clientID != nil, "Please configure an Imgur client ID. For information on how to do this, please view ImgurUploader.swift")
        self.clientID = clientID!
    }
    
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