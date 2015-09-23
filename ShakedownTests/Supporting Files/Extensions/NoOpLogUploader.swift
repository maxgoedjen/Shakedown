import Foundation
@testable import Shakedown

class NoOpSuccessLogUploader: LogUploader {
    func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion) {
        completion(url: NSURL(string: "http://gist.github.com/anonymous/asdf"), error: nil)
    }
}

class NoOpFailureLogUploader: LogUploader {
    func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion) {
        completion(url: nil, error: NSError(domain: "NoOpFailure", code: 500, userInfo: nil))
    }
}
