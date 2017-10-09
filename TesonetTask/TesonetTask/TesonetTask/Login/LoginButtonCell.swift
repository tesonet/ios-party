//
//  LoginButtonCell.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class LoginButtonCell: NSButtonCell {
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        var backgroundColor : NSColor
        if isHighlighted && isEnabled {
            backgroundColor = NSColor.green
        } else if isEnabled {
        	backgroundColor = NSColor.TNGreenColor
        } else {
            backgroundColor = NSColor.lightGray
        }
        
        let border = NSBezierPath(roundedRect: NSInsetRect(cellFrame, 0.5, 0.5), xRadius: 3, yRadius: 3)
        backgroundColor.set()
        border.fill()

        let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .center
        let attr : [String:Any] = [NSParagraphStyleAttributeName : paragraph, NSForegroundColorAttributeName : NSColor.white]
		
        var titleRect : NSRect = NSRect()
        titleRect.size = (title as NSString).size(withAttributes: attr)
        titleRect.origin.x = controlView.bounds.midX - titleRect.size.width / 2
        titleRect.origin.y = controlView.bounds.midY - titleRect.size.height / 2
        self.title.draw(in: titleRect, withAttributes: attr)
	}
    
}
