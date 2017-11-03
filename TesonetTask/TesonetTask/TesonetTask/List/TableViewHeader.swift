//
//  TableViewHeader.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class TableViewHeader: NSView {
	
    @IBOutlet private weak var serverTextField: NSTextField!
    @IBOutlet private weak var distanceTextField: NSTextField!
    
    override func awakeFromNib() {
		super.awakeFromNib()
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        
        serverTextField.textColor = NSColor.TNSeparatorGrayColor
        serverTextField.stringValue = NSLocalizedString("cServerTextFieldText", comment:"")
        
        distanceTextField.textColor = NSColor.TNSeparatorGrayColor
        distanceTextField.stringValue = NSLocalizedString("cDistanceTextFieldText", comment:"")
	}
    
}
