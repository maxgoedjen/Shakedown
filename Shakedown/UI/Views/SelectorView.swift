import UIKit

public protocol SelectorViewDelegate: AnyObject {
    func selectorChoseItem(selector: SelectorView, item: String)
}

public class SelectorView: UIControl {
    
    public weak var delegate: SelectorViewDelegate?
    public var options: [String] = [] {
        didSet {
            configureView()
        }
    }
    
    private var buttons: [UIButton] = []
    private var backing: UIView
    
    override init(frame: CGRect) {
        backing = UIView(frame: CGRectZero)
        super.init(frame: frame)
        configureView()
    }
    
    public required init(coder aDecoder: NSCoder) {
        backing = UIView(frame: CGRectZero)
        super.init(coder: aDecoder)
        configureView()
    }
    
    public func configureView() {
        backing.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backing.alpha = 0
        addSubview(backing)
        let views = ["v" : backing]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options: nil, metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options: nil, metrics: nil, views: views))
    }
    
    public func configureButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = options.map {
            let button = UIButton(frame: CGRectZero)
            button.setTitle($0, forState: .Normal)
            return button
        }
        for button in buttons {
//            addSubview(button)
        }
    }
    
    public func displayFromButton(button: UIButton) {
        UIView.animateWithDuration(1) {
            self.backing.alpha = 1
        }
        for button in buttons {
            
        }
    }
    
}