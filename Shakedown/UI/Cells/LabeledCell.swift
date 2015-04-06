//
//  LabeledCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 4/5/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

class LabeledCell: ShakedownCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet var contentConstraint: NSLayoutConstraint!
    
    func showLabel(animated: Bool = true) {
        labelTopConstraint.constant = 5
        contentConstraint.constant = shownContentConstraint
        let action: (Void -> Void) = {
            self.label.alpha = 1
            self.layoutIfNeeded()
        }
        if animated {
            UIView.animateWithDuration(0.5, action)
        } else {
            action()
        }
    }
    
    func hideLabel(animated: Bool = true) {
        labelTopConstraint.constant = 20
        contentConstraint.constant = hiddenContentConstraint
        let action: (Void -> Void) = {
            self.label.alpha = 0
            self.layoutIfNeeded()
        }
        if animated {
            UIView.animateWithDuration(0.5, action)
        } else {
            action()
        }
    }
    
    var shownContentConstraint: CGFloat {
        return 5
    }
    
    var hiddenContentConstraint: CGFloat {
        return 0
    }
    
}