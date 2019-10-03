//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Артём Зиньков on 10/1/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit
import Network

final class ServerListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    
    private var serverModels: [ServerModel] = [] { didSet { tableView.reloadData() } }
    private let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                APIManager.shared.getServers({ servers in
                    self?.serverModels = servers
                    servers.forEach { DBManager.shared.save($0) }
                }) { error in
                    Router.route(to: .Error(description: error.localizedDescription))
                }
            } else if let servers = DBManager.shared.getServers() {
                self?.serverModels = servers.map { return ServerModel(name: $0.serverName ?? "", distance: Int($0.distance)) }
            }
            self?.monitor.cancel()
        }
        monitor.start(queue: DispatchQueue.main)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logo-dark"),
                                                           style: .plain,
                                                           target: self,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico-logout"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logout))
        tableView.contentInset = .init(top: 0, left: 0, bottom: sortButton.frame.height, right: 0)
    }
    
    @objc func logout() {
        APIManager.reset()
    }
    
    @IBAction func sort() {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "By Distance", style: .default, handler: { [weak self] _ in
            self?.serverModels.sort(by: { return $0.distance < $1.distance })
        }))
        alertController.addAction(UIAlertAction(title: "Alphanumerical", style: .default, handler: { [weak self] _ in
            self?.serverModels.sort(by: { return $0.name < $1.name })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true)
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
