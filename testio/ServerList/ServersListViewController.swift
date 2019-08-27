//
//  ServerListViewController.swift
//  testio
//
//  Created by Justinas Baronas on 17/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit

private let kCellRowHeight: CGFloat = 44

class ServersListViewController: UIViewController {
    
    @IBOutlet weak var serversListTableView: UITableView!
    @IBOutlet weak var serverListHeaderView: UIView!
    
    
    private var servers: [Server]? {
        didSet {
            serversListTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    
    // MARK: - Life cycle
    
    convenience init(with servers: [Server]) {
        self.init()
        self.servers = servers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderShadow()
    }
    
    
    // MARK: - Setup
    
    private func setupTableView() {
        serversListTableView.register(
            ServerListTableViewCell.nib(),
            forCellReuseIdentifier: ServerListTableViewCell.reuseIdentifier)
        serversListTableView.dataSource = self
        serversListTableView.rowHeight = UITableView.automaticDimension
        serversListTableView.estimatedRowHeight = kCellRowHeight
    }
    
    
    // MARK: - Actions
    @IBAction func onLogoutTapAction(_ sender: Any) {
        Authentication.clearUserCredentials()
        AppNavigator.shared.navigate(from: self, to: .loginView)
    }
    
    @IBAction func onServerSortTapAction(_ sender: Any) {
        guard let servers = servers else { return }
        
        if servers == servers.sorted { $0.name > $1.name } {
            self.servers = servers.sorted { $0.name < $1.name }
        } else {
            self.servers = servers.sorted { $0.name > $1.name }
        }
    }
    
    @IBAction func onDistanceSortTapAction(_ sender: Any) {
        guard let servers = servers else { return }
        
        if servers == servers.sorted { $0.distance < $1.distance } {
            self.servers = servers.sorted { $0.distance > $1.distance }
        } else {
            self.servers = servers.sorted { $0.distance < $1.distance }
        }
    }
    
}

// MARK: - ServerListHeaderView Style

extension ServersListViewController {
    func setupHeaderShadow() {
       serverListHeaderView.layer.masksToBounds = false
       serverListHeaderView.layer.shadowOffset = CGSize(width: 0, height: 10)
       serverListHeaderView.layer.shadowRadius = 7
       serverListHeaderView.layer.shadowOpacity = 0.9
       serverListHeaderView.layer.shadowColor = UIColor(red: 222/255, green: 225/255, blue: 229/255, alpha: 1).cgColor
    }
}


// MARK: - TableView Flow

extension ServersListViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let servers = servers else {
            return 0
        }
        
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServerListTableViewCell =  tableView.dequeueReusableCell(for: indexPath)
        
        if let server = servers?[indexPath.row] {
            cell.setupCell(with: server)
        }
        
        return cell
    }
}
