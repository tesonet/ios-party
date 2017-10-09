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
    internal var dataHandler: DataHandler = DataHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginViewController = mainStoryboard.instantiateController(withIdentifier: "loginViewController") as! LoginViewController
        loginViewController.containerViewController = self
        if let username = presenter.username {
            loginViewController.setup(username:username)
        }
        
        self.insertChildViewController(loginViewController, at: 0)
        self.view.addSubview(loginViewController.view)
        self.view.frame = loginViewController.view.frame
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let _ = presenter.username, let _ = presenter.token {
            presenter.containerVCdidRequestLogin(vc: self, username: "", password: "")
        }
    }
    
}

extension ContainerViewController : ListViewControllerDelegate {
	
    internal func didRequestLogOut(vc: ListViewController) {
		presenter.didRequestLogOut(vc: self)
	}
    
    internal func didRequestLoadData(vc:ListViewController) {
    	dataHandler.loadData()
    }
    
}

extension ContainerViewController : LoginViewControllerDelegate {
    
    func loginViewControllerdidRequestLogin(vc: LoginViewController, username: String, password: String) {
    	presenter.containerVCdidRequestLogin(vc:self, username: username, password: password)
    }
    
}

