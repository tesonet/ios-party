//
//  SpinnerView.swift
//  GreatiOSApp
//
//  Created by Domas on 4/6/17.
//  Copyright © 2017 Sonic Team. All rights reserved.
//

import UIKit

@IBDesignable
class SpinnerView : UIView {
    var gradientRingLayer = GradientCircle()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientRingLayer = GradientCircle(bounds: CGRect(origin: CGPoint.zero,size:CGSize(width: self.frame.size.width, height: self.frame.size.width)), position:CGPoint(x: self.frame.size.width/2, y: self.frame.size.width/2),fromColor:UIColor.white, toColor:UIColor.clear, linewidth:5.0, toValue:0)
        self.layer.addSublayer(gradientRingLayer)
    }
    
    public func startAnimation() {
        gradientRingLayer.animateCircleTo(duration: 0.0, fromValue: 0, toValue: 0.99)
        self.animate()
    }
    
    public func stopAnimation() {
        gradientRingLayer.removeAllAnimations()
    }
    
    private func animate() {
        animateKeyPath("transform.rotation")
    }
    
    private func animateKeyPath(_ keyPath: String) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = [CGFloat(0), 2 * CGFloat(Double.pi)]
        animation.calculationMode = kCAAnimationLinear
        animation.duration = 3.0
        animation.repeatCount = Float.infinity
        gradientRingLayer.add(animation, forKey: animation.keyPath)
    }
}
