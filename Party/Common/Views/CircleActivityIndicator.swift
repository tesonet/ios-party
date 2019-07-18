//
//  CircleActivityIndicator.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class CircleActivityIndicator : UIView {
    
    private let animationLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()
    
    private let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 1
        animation.repeatCount = .infinity
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(animationLayer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.addSublayer(animationLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animationLayer.frame = bounds
        animationLayer.colors = [UIColor.white, UIColor.clear].map { $0.cgColor }
        
        let lineWidth: CGFloat = 5
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0,
                                endAngle: 2 * .pi,
                                clockwise: true)
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = lineWidth
        mask.path = path.cgPath
        
        animationLayer.mask = mask
        animationLayer.add(rotationAnimation, forKey: nil)
    }
}
