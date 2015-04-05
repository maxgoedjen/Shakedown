//
//  ShakedownCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/18/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

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
        divider.addConstraint(NSLayoutConstraint(item: divider, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: height, constant: 1))
    }
    
    class var identifier: String {
        return ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        divider.hidden = false
    }
    
}