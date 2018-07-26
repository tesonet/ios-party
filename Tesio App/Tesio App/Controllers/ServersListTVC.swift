//
//  ServersListTVC.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/26/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit
import Foundation

private extension Selector {
    static let logoutPressed = #selector(ServersListTVC.logoutPressed)
}

class ServersListTVC: UITableViewController {
    
    
    // MARK: Enums
    private enum Strings {
        static let logoutIconName = "logoutIcon"
        static let logoImageName = "logoDark"
    }

    // MARK: Vars
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setupNavigationBar()
    }

    
    // MARK: - Methods
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(image: UIImage(named: Strings.logoutIconName)?.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: .logoutPressed)
        navigationItem.rightBarButtonItem = logoutButton
        
        let logoImage = UIBarButtonItem(image: UIImage(named: Strings.logoImageName)?.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: nil)
        navigationItem.leftBarButtonItem = logoImage
    }
    
    @objc func logoutPressed() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

   

}
