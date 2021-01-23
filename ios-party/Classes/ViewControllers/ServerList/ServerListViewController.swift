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
        registerTableViewCells()
    }

    // MARK: - ServerListDataModelDelegate
    func serverListDataModel(didSortServerList: ServerListDataModelInterface) {
        tableView.reloadData()
    }
}
