//
//  NSTableViewAdditions.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

extension NSTableView {
	
    internal func registerNib(cellClass:IBaseCell.Type) {
    	if let nib : NSNib = cellClass.cellClass.Nib() {
    		self.register(nib, forIdentifier: cellClass.identifier)
        } else {
        	NSLog("error on registering Nib")
        }
    }
    
    internal func makeView<T>(cellClass:IBaseCell.Type) -> T? where T : NSView {
    	return self.make(withIdentifier: cellClass.identifier, owner: nil) as? T
    }
        
}
