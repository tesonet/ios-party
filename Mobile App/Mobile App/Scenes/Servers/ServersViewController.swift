//
//  ServersViewController.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit

final class ServersViewController: UIViewController {
    
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    
    private lazy var loadingVC: UIViewController = ServersLoadingViewController.createFrom(storyboard: .servers)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private func showLoading() {
        addChild(loadingVC)
        view.addSubview(loadingVC.view)
        loadingVC.didMove(toParent: self)
    }
    
    private func hideLoading() {
        loadingVC.willMove(toParent: nil)
        loadingVC.removeFromParent()
        loadingVC.view.removeFromSuperview()
    }
    
}
