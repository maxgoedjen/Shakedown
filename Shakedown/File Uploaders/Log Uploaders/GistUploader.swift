import Foundation

public struct GistUploader: LogUploader {
    
    let authenticationToken: String?
    
    public init(authenticationToken: String? = nil) {
        self.authenticationToken = authenticationToken
    }
    
    public func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion) {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/gists")!)
        let requestBody = ["files": [
            "Configuration.md" : ["content" : formattedConfiguration(deviceConfiguration)],
            "Log.txt" : ["content" : log]
        ]]
        let logData = NSJSONSerialization.dataWithJSONObject(requestBody, options: nil, error: nil)
        request.HTTPBody = logData
        request.HTTPMethod = "POST"
        if let token = authenticationToken {
            request.allHTTPHeaderFields = ["Authorization" : "token \(token)"]
        }
        session.dataTaskWithRequest(request) { data, response, error in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
            let urlString = json?["html_url"] as? String ?? ""
            completion(url: NSURL(string: urlString), error: error ?? response.httpError)
            }.resume()
    }
    
    private func formattedConfiguration(configuration: [String : String]) -> String {
        var strung = ""
        for (key, value) in configuration {
            strung += "`\(key)` : `\(value)`\n\n"
        }
        return strung
    }
    
}