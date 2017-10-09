//
//  ContainerViewController.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController {
    private let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
    fileprivate let presenter: ContainerViewControllerPresenter = ContainerViewControllerPresenter()
    fileprivate let dataHandler: DataHandler = DataHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginViewController = mainStoryboard.instantiateController(withIdentifier: "loginViewController") as! NSViewController
        self.insertChildViewController(loginViewController, at: 0)
        self.view.addSubview(loginViewController.view)
        self.view.frame = loginViewController.view.frame
    }
    
}

extension ContainerViewController : ListViewControllerDelegate {
	
    internal func didRequestLogOut(vc: ListViewController) {
		presenter.didRequestLogOut(vc: vc)
	}
    
    internal func didRequestLoadData(vc:ListViewController) {
    	dataHandler.loadData()
    }
    
}

extension ContainerViewController : LoadingViewControllerDelegate {
	
    internal func didLoadData(vc: LoadingViewController) {
		presenter.didLoadData(vc: vc)
	}
    
    internal func didFailLoadData(vc: LoadingViewController) {
		presenter.didFailLoadData(vc: vc)
	}
}

extension ContainerViewController : LoginViewControllerDelegate {
    
    func didRequestLogin(vc:LoginViewController) {
    	presenter.didRequestLogin(vc: vc)
    }
    
}

