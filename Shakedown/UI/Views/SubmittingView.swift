//
//  SubmittingView.swift
//  Shakedown
//
//  Created by Max Goedjen on 11/21/15.
//  Copyright © 2015 Max Goedjen. All rights reserved.
//

import UIKit

class SubmittingView: UIView {
    
    
    let backing = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    static let paths: [UIBezierPath] = {
        return [UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 206), cornerRadius: 10),
            UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: 96, height: 202), cornerRadius: 8),
            UIBezierPath(roundedRect: CGRect(x: 42, y: 13, width: 16, height: 2), cornerRadius: 1),
            UIBezierPath(ovalInRect: CGRect(x: 42, y: 185, width: 16, height: 16)),
            UIBezierPath(ovalInRect: CGRect(x: 43, y: 186, width: 14, height: 14)),
            UIBezierPath(rect: CGRect(x: 6, y: 25, width: 88, height: 157))]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    let shapeLayers: [CAShapeLayer] = {
        return paths.map { path in
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.strokeColor = UIColor.whiteColor().CGColor
            shapeLayer.lineWidth = 1
            shapeLayer.path = path.CGPath
            shapeLayer.position = CGPoint(x: 137, y: 200)
            return shapeLayer
        }
    }()
    
    func setupView() {
        backgroundColor = UIColor.blackColor()
        let views = ["v": backing]
        addSubview(backing)
        backing.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options: [], metrics: nil, views: views))
        for shapeLayer in shapeLayers {
            layer.addSublayer(shapeLayer)
        }
        
    }
    
    func animate() {
        for shapeLayer in shapeLayers {
            shapeLayer.strokeEnd = 1
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 3
            shapeLayer.addAnimation(animation, forKey: "stroke")
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animate()
    }
    
}