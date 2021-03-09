//
//  ViewController.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    var rootCoordinator: CoordinatorProtocol?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootCoordinator = LoginCoordinator(with: self)
        rootCoordinator?.start()
    }


}

