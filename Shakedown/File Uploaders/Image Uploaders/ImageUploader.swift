import UIKit

public typealias ImageUploadCompletion = (url: NSURL?, error: NSError?) -> Void

public protocol ImageUploader {
    
     func uploadImage(image: UIImage, completion: ImageUploadCompletion)
    
}