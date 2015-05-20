import UIKit

class ButtonCell: ShakedownCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    override class var identifier: String {
        return "ButtonCell"
    }
    
    override func prepareForReuse() {
        button.removeTarget(self, action: nil, forControlEvents: .AllEvents)
    }

}