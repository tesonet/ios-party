//
//  ServersListMainViewController.swift
//  ios-party
//
//  Created by Adomas on 28/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import UIKit

class ServersListViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var serversTableView: UITableView!
    
    var model: ServerListModel!
        
    init(model: ServerListModel) {
        super.init(nibName: String(describing:ServersListViewController.self), bundle: nil)
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serversTableView.register(UINib(nibName: "ServerTableViewCell", bundle:  nil), forCellReuseIdentifier: "ServerTableViewCell")
        
        setupUI()
    }
    
    @IBAction func logoutPressed() {
        let keychainPassword = KeychainPassword()
        do {
            try keychainPassword.delete()
            UserDefaults.standard.set(nil, forKey: Keys.usernameKey)
        } catch {
            
        }
        dismiss(animated: true)
    }
    
    func setupUI() {
        let shadowPath = UIBezierPath(rect: headerView.bounds)
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowPath = shadowPath.cgPath
    }
}

//MARK: UITableViewDataSource

extension ServersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = serversTableView.dequeueReusableCell(withIdentifier: String(describing: ServerTableViewCell.self), for: indexPath) as? ServerTableViewCell else {
            return UITableViewCell()
        }
        cell.setupUI(server: model.servers[indexPath.row])
        
        return cell
    }
}
