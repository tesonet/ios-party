//
//  ServerListViewController.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

class ServerListViewController: BaseViewController,
                                ServerListDataModelDelegate,
                                UITableViewDataSource,
                                UITableViewDelegate {
    
    // MARK: - Declarations
    var dataModel: ServerListDataModelInterface!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = ServerListDataModel(delegate: self)
        
        for server in dataModel.serverList {
            log(server.name)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.serverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        return cell
    }


    // MARK: - ServerListDataModelDelegate
}
