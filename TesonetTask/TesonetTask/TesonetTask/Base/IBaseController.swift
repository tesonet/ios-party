//
//  IBaseController.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

protocol IBaseController: class {
	var controller : NSViewController {get}
    weak var containerViewController : ContainerViewController? {get set}
    func resetConstrains()
}

extension IBaseController {
	var controller : NSViewController {
    	return self as! NSViewController
    }
}
