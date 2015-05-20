import UIKit
import ShakedownSample

class NoOpSuccessImageUploader: ImageUploader {
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
        completion(url: NSURL(string: "http://imgur.com/asdf"), error: nil)
    }
}

class NoOpFailureImageUploader: ImageUploader {
    func uploadImage(image: UIImage, completion: ImageUploadCompletion) {
        completion(url: nil, error: NSError(domain: "NoOpFailure", code: 500, userInfo: nil))
    }
}
