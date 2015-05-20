import Foundation

extension NSURLResponse {
    
    var httpError: NSError? {
        if let response = self as? NSHTTPURLResponse {
            if 200..<300 ~= response.statusCode {
                return nil
            } else {
                return NSError(domain: "NSURLHTTPResponseErrorDomain", code: response.statusCode, userInfo: nil)
            }
        }
        return nil
    }
    
}