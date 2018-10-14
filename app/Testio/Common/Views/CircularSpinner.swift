//
//  CircularSpinner.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

@IBDesignable
class CircularSpinner: UIView {
    
    @IBInspectable var strokeThickness: CGFloat = 2 {
        didSet {
            indefiniteAnimatedLayer.lineWidth = strokeThickness
        }
    }
    
    @IBInspectable var strokeColor: UIColor = .white {
        didSet {
            indefiniteAnimatedLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    fileprivate var radius: CGFloat {
        get {
            return min(bounds.size.height, bounds.size.width) / 2.0
        }
    }
    
    fileprivate var animatedLayer: CAShapeLayer?
    
    fileprivate var indefiniteAnimatedLayer: CAShapeLayer {
        get {
            if let currentLayer = animatedLayer {
                return currentLayer
            } else {
                let arcCenter = CGPoint(x: radius + strokeThickness/2+5,
                                        y: radius + strokeThickness/2+5)
                let smoothedPath = UIBezierPath(arcCenter: arcCenter,
                                                radius: radius,
                                                startAngle: CGFloat(Float.pi * 3.0 / 2.0),
                                                endAngle: CGFloat(Float.pi / 2.0 + Float.pi * 5.0),
                                                clockwise: true)
                animatedLayer = CAShapeLayer()
                animatedLayer?.contentsScale = UIScreen.main.scale
                animatedLayer?.frame = CGRect(x: 0.0, y: 0.0, width: arcCenter.x*2, height: arcCenter.y*2)
                animatedLayer?.fillColor = UIColor.clear.cgColor
                animatedLayer?.strokeColor = strokeColor.cgColor
                animatedLayer?.lineWidth = strokeThickness
                animatedLayer?.lineCap = CAShapeLayerLineCap.square
                animatedLayer?.lineJoin = CAShapeLayerLineJoin.bevel
                animatedLayer?.path = smoothedPath.cgPath
                
                let maskLayer = CALayer()
                
                maskLayer.contents = UIImage(named: "CircularSpinnerMaskImage")?.cgImage
                maskLayer.frame = (animatedLayer?.bounds)!
                animatedLayer?.mask = maskLayer
                
                let animationDuration = 0.5
                let linearCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                
                let animation = CABasicAnimation(keyPath: "transform.rotation")
                animation.fromValue = 0
                animation.toValue = Float.pi * 2
                animation.duration = animationDuration
                animation.timingFunction = linearCurve;
                animation.isRemovedOnCompletion = false;
                animation.repeatCount = Float.infinity;
                animation.fillMode = CAMediaTimingFillMode.forwards;
                animation.autoreverses = false;
                animatedLayer?.mask?.add(animation, forKey: "rotate")
                
                let animationGroup = CAAnimationGroup()
                animationGroup.duration = animationDuration;
                animationGroup.repeatCount = Float.infinity;
                animationGroup.isRemovedOnCompletion = false;
                animationGroup.timingFunction = linearCurve;
                
                let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
                strokeStartAnimation.fromValue = 0.015;
                strokeStartAnimation.toValue = 0.515;
                
                let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
                strokeEndAnimation.fromValue = 0.485;
                strokeEndAnimation.toValue = 0.985;
                
                animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
                animatedLayer?.add(animationGroup, forKey: "progress")
                
                return animatedLayer!
            }
        }
    }
    
    func layoutAnimatedLayer() {
        let layer = indefiniteAnimatedLayer
        self.layer.addSublayer(layer)
        
        let widthDiff = bounds.size.width - layer.bounds.size.width
        let heightDiff = bounds.size.height - layer.bounds.size.height
        
        layer.position = CGPoint(x: bounds.size.width - layer.bounds.size.width / 2 - widthDiff / 2,
                                 y: bounds.size.height - layer.bounds.size.height / 2 - heightDiff / 2)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        indefiniteAnimatedLayer.removeFromSuperlayer()
        deleteLayer()
        
        if newSuperview == nil {
            layoutAnimatedLayer()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (superview != nil) {
            layoutAnimatedLayer()
        }
    }
    
    func deleteLayer() {
        animatedLayer = nil
    }
    
    func sizeThatFits(size sizeToFit: CGSize) -> CGSize {
        return CGSize(width: (radius+strokeThickness/2+5)*2,
                      height: (radius+strokeThickness/2+5)*2)
    }
}
