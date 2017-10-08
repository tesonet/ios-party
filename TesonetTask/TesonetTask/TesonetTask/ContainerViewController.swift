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

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginViewController = mainStoryboard.instantiateController(withIdentifier: "loginViewController") as! NSViewController
        self.insertChildViewController(loginViewController, at: 0)
        self.view.addSubview(loginViewController.view)
        self.view.frame = loginViewController.view.frame
    }
    
}
