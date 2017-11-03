//
//  NSViewAdditions.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

extension NSView {

    internal static func createFromNib() -> NSView? {
        var topLevelObjects = NSArray()
        if Bundle.main.loadNibNamed(NibName(), owner: self, topLevelObjects: &topLevelObjects) {
           let views = (topLevelObjects as Array).filter { $0 is NSView }
           return views[0] as? NSView
        }
        return nil
    }
    
    internal static func Nib() -> NSNib? {
    	return NSNib(nibNamed: NibName(), bundle: Bundle.main)
    }
    
    internal static func NibName() -> String {
    	return String(describing: self)
    }
    
    internal func fillSuperview() {
    	if let theSuperView = superview {
        	translatesAutoresizingMaskIntoConstraints = false
        	theSuperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view":self]))
            theSuperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view":self]))
        }
    }
    
    internal func centerInSuperView() {
    	if let theSuperView = superview {
        	translatesAutoresizingMaskIntoConstraints = false
            theSuperView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: theSuperView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            theSuperView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: theSuperView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
    }
    
    internal func addHeightConstraint(height:CGFloat) {
    	translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
    }
    
    internal func addWidthConstraint(width:CGFloat) {
    	translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: width))
    }
    
}

extension NSView {

    func spinClockwise(timeToRotate: Double) {
        startRotate(angle: CGFloat(-1 * Double.pi * 2.0), timeToRotate: timeToRotate)
    }

    func spinAntiClockwise(timeToRotate: Double) {
        startRotate(angle: CGFloat(Double.pi * 2.0), timeToRotate: timeToRotate)
    }

    func startRotate(angle: CGFloat, timeToRotate: Double) {

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = angle
        rotateAnimation.duration = timeToRotate
        rotateAnimation.repeatCount = .infinity
        self.layer?.anchorPoint = CGPoint(x:0.5, y:0.5)
        let x = superview!.frame.width / 2
        let y = superview!.frame.height / 2
		self.layer?.position = CGPoint(x:x, y:y)
        
        self.layer?.add(rotateAnimation, forKey: nil)
    }

    func stopAnimations() {
        self.layer?.removeAllAnimations()
    }
}
