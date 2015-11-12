import Foundation

extension NSURLResponse {
    
    var httpError: NSError? {
        guard let response = self as? NSHTTPURLResponse else { return nil }
        if 200..<300 ~= response.statusCode {
            return nil
        } else {
            return NSError(domain: "NSURLHTTPResponseErrorDomain", code: response.statusCode, userInfo: nil)
        }
    }
    
}