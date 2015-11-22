//
//  SubmittingView.swift
//  Shakedown
//
//  Created by Max Goedjen on 11/21/15.
//  Copyright © 2015 Max Goedjen. All rights reserved.
//

import UIKit

class SubmittingView: UIView {
    
    let iPhonePath: UIBezierPath = {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 90, y: 10))
        path.addArcWithCenter(<#T##center: CGPoint##CGPoint#>, radius: <#T##CGFloat#>, startAngle: <#T##CGFloat#>, endAngle: <#T##CGFloat#>, clockwise: <#T##Bool#>)
        return path
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.clearColor()
        let backing = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        let views = ["v": backing]
        addSubview(backing)
        backing.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options: [], metrics: nil, views: views))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = iPhonePath.CGPath
        layer.addSublayer(shapeLayer)
        layer.bounds.size = CGSize(width: 100, height: 100)
        layer.position = center
    }
    
    func animate() {
        
    }
    
}