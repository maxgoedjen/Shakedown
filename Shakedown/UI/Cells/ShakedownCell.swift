import UIKit

protocol ShakedownCellDelegate {
    
    func cell(cell: ShakedownCell, valueChanged newValue: String)
    
}

class ShakedownCell : UICollectionViewCell {
    
    @IBOutlet var divider: UIView!
    var delegate: ShakedownCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let height = 1.0/UIScreen.mainScreen().scale
        addConstraint(NSLayoutConstraint(item: divider, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height))
    }
    
    class var identifier: String {
        return ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        divider.hidden = false
    }
    
}