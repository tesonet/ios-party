//
//  TableRowView.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class TableRowView: NSTableRowView, IBaseCell {
    @IBOutlet private weak var serverTextField: NSTextField!
    @IBOutlet private weak var distanceTextField: NSTextField!
    @IBOutlet private weak var separatorView: NSView!
    
    static var cellClass: NSView.Type {
    	return self
    }
    
    static var cellHeight: CGFloat {
    	return 50.0
    }
    
    override func awakeFromNib() {
		super.awakeFromNib()
        distanceTextField.textColor = NSColor.TNTextGrayColor
        serverTextField.textColor = NSColor.TNTextGrayColor
        
        separatorView.wantsLayer = true
        separatorView.layer?.backgroundColor = NSColor.TNSeparatorGrayColor.cgColor
	}
    
    internal func configure(model:ServerModel) {
        serverTextField.stringValue = model.name
        distanceTextField.stringValue = String(model.distance)
    }
    
}
