import UIKit
import CoreImage

extension UIImage {
    
    var blurred: UIImage? {
        let ciimage = CoreImage.CIImage(CGImage: CGImage!)
        guard let filter = CIFilter(name: "CIGaussianBlur") else { return self }
        filter.setValue(ciimage, forKey: kCIInputImageKey)
        filter.setValue(10, forKey: "inputRadius")
        guard let image = filter.outputImage else { return self }
        return UIImage(CIImage: image)
    }
    
}