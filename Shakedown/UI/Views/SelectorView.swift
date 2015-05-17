import UIKit

public protocol SelectorViewDelegate: AnyObject {
    func selectorChoseItem(selector: SelectorView, item: String)
}

public class SelectorView: UIControl {
    
    public weak var delegate: SelectorViewDelegate?
    public var options: [String] = [] {
        didSet {
            configureButtons()
        }
    }
    
    private var buttons: [UIButton] = []
    private var verticalConstraints: [NSLayoutConstraint] = []
    private var sourceButton: UIButton?
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
        alpha = 0
        backgroundColor = UIColor.clearColor()
        backing.backgroundColor = UIColor(white: 0, alpha: 0.75)
        backing.alpha = 0
        backing.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(backing)
        addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: backing, attribute: .Leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: backing, attribute: .Trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: backing, attribute: .Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: backing, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    public func configureButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        for _ in 0...count(options) {
            let button = UIButton.buttonWithType(.System) as! UIButton
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
            button.setTitleColor(UIColor.shakedownBlueColor, forState: .Normal)
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.addTarget(self, action: "selectedButton:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    public func displayFromButton(sourceButton: UIButton) {
        var reorderedOptions = options
        let currentValue = sourceButton.currentTitle!
        reorderedOptions.removeAtIndex(find(options, currentValue)!)
        reorderedOptions.insert(currentValue, atIndex: 0)
        alpha = 1
        self.sourceButton = sourceButton
        let translated = convertRect(sourceButton.frame, fromView: sourceButton.superview)
        resetButtons()
        for (button, option) in zip(buttons, reorderedOptions) {
            button.setTitle(option, forState: .Normal)
        }
        self.layoutIfNeeded()
        removeConstraints(verticalConstraints)
        verticalConstraints = []
        var lastButton: UIButton? = nil
        for button in buttons {
            button.alpha = 0
            let vertical: NSLayoutConstraint
            if let last = lastButton {
                vertical = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: last, attribute: .Bottom, multiplier: 1, constant: 8)
            } else {
                vertical = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: translated.origin.y)
            }
            addConstraint(vertical)
            verticalConstraints.append(vertical)
            lastButton = button
        }
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: {
            for button in self.buttons {
                button.alpha = 1
            }
            self.layoutIfNeeded()
        }, completion: nil)
        UIView.animateWithDuration(0.5) {
            self.backing.alpha = 1
        }
    }
    
    func selectedButton(sender: UIButton) {
        delegate?.selectorChoseItem(self, item: sender.currentTitle!)
        removeConstraints(verticalConstraints)
        verticalConstraints = []
        resetButtons()
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: {
            self.layoutIfNeeded()
            for button in self.buttons {
                button.alpha = 0
            }
            }, completion: nil)
        UIView.animateWithDuration(0.5, animations: {
            self.backing.alpha = 0
        }) { _ in
            self.alpha = 0
        }
    }
    
    private func resetButtons() {
        let translated = convertRect(sourceButton!.frame, fromView: sourceButton!.superview)
        for button in buttons {
            let constraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: translated.origin.y)
            verticalConstraints.append(constraint)
            addConstraint(constraint)
            addConstraint(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: translated.origin.x))
        }

    }
    
}