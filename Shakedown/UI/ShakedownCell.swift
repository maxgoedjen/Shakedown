//
//  ShakedownCell.swift
//  ShakedownSample
//
//  Created by Max Goedjen on 3/18/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

import UIKit

protocol ShakedownCellDelegate {
    func valueChanged(cell: ShakedownCell, newValue: String)
}

class ShakedownCell : UICollectionViewCell {
    var delegate: ShakedownCellDelegate?
}