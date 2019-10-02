//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Артём Зиньков on 10/1/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

final class ServerListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    
    private var serverModels: [ServerModel] = [] { didSet { tableView.reloadData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getServers({ [weak self] servers in
            self?.serverModels = servers
        }) { error in
            Router.route(to: .Error(description: error.localizedDescription))
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        APIManager.reset()
    }
    
    @IBAction func sort() {
        
    }
}

extension ServerListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let serverCell = tableView.dequeueReusableCell(withIdentifier: "ServerCell") as? ServerCell,
            let serverModel = serverModels[safe: indexPath.row] {
            
            serverCell.serverLabel.text = serverModel.name
            serverCell.distanceLabel.text = serverModel.distance.description
            
            return serverCell
        }
        
        return ServerCell()
    }
}
