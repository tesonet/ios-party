//
//  IBaseCell.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

protocol IBaseCell: class {
	static var identifier : String {get}
    static var NibName : String {get}
    static var cellClass : NSView.Type {get}
    static var cellHeight : CGFloat {get}
}

extension IBaseCell {
	
    internal static var NibName : String {
    	return identifier
    }
    
    internal static var identifier : String {
    	return cellClass.NibName()
    }
    
}
