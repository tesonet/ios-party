//
//  ContainerViewControllerPresenter.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class ContainerViewControllerPresenter: NSObject {
	
    internal func didRequestLogOut(vc: ContainerViewController) {
        if let topController = vc.childViewControllers.first {
            topController.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
	}
    
    internal func didLoadData(vc: ContainerViewController) {
        if let topController = vc.childViewControllers.first {
            topController.performSegue(withIdentifier: "listViewControllerSegue", sender: self)
        }
	}
    
    internal func didFailLoadData(vc: ContainerViewController) {

	}
    
    func didRequestLogin(vc: ContainerViewController) {
        if let topController = vc.childViewControllers.first {
            topController.performSegue(withIdentifier: "loadingSegue", sender: self)
        }
    }
    
}
