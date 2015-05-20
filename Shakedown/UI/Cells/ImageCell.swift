import UIKit

class ImageCell: ShakedownCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override class var identifier: String {
        return "ImageCell"
    }

}