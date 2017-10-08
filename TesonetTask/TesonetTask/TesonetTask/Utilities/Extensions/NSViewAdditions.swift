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
    
}
