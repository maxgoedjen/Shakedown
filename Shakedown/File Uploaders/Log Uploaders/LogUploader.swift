import Foundation

public typealias LogUploadCompletion = (url: NSURL?, error: NSError?) -> Void

public protocol LogUploader {
    func uploadLog(log: String, deviceConfiguration: [String : String], completion: LogUploadCompletion)
}