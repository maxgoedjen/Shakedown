//
//  SubmittingView.swift
//  Shakedown
//
//  Created by Max Goedjen on 11/21/15.
//  Copyright © 2015 Max Goedjen. All rights reserved.
//

import UIKit

class SubmittingView: UIView {
    
    let shapeLayer = CAShapeLayer()
    let iPhonePath: UIBezierPath = {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 10, y: 10))
        path.addLineToPoint(CGPoint(x: 90, y: 10))
        path.moveToPoint(CGPoint(x: 10, y: 20))
        path.addLineToPoint(CGPoint(x: 90, y: 20))
        path.moveToPoint(CGPoint(x: 10, y: 30))
        path.addLineToPoint(CGPoint(x: 90, y: 30))
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
        
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = iPhonePath.CGPath
        layer.addSublayer(shapeLayer)
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func animate() {
        shapeLayer.strokeEnd = 0
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 10
        shapeLayer.addAnimation(animation, forKey: "stroke")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animate()
    }
    
}