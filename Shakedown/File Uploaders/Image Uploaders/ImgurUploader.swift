import UIKit

/*
    Application Transport Security Note:
    Imgur does not currently support forward secrecy, so your app will need to configure an exemption for that domain. 

    <key>NSAppTransportSecurity</key>
    <dict>
    <key>NSExceptionDomains</key>
    <dict>
    <key>imgur.com</key>
    <dict>
    <key>NSExceptionRequiresForwardSecrecy</key>
    <false/>
    <key>NSIncludesSubdomains</key>
    <true/>
    </dict>
    </dict>
    </dict>

*/

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
            let data = try? NSJSONSerialization.JSONObjectWithOptionalData(data)
            let imgurData = data?["data"] as? [String : AnyObject]
            let urlString = imgurData?["link"] as? String ?? ""
            completion(url: NSURL(string: urlString), error: error ?? response?.httpError)
        }.resume()
    }

}