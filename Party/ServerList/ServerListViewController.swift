//
//  ServerListViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class ServerListViewController: BaseViewController, Alertable {

    // MARK: - UI Components
    
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - States
    
    var dataModel: ServerListDataModel!
    
    // MARK: - Override superclass
    
    override func configureAfterInit() {
        dataModel = ServerListDataModel(delegate: self,
                                        apiClient: ApiClient.shared)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellNib(withType: ServerCell.self)
        
        dataModel.loadData()
    }
}

// MARK: -

extension ServerListViewController: ServerListDataModelDelegate {
    
    // MARK: - ServerListDataModelDelegate
    
    func serverListDataModelDidLoad(_ dataModel: ServerListDataModel) {
        tableView.reloadData()
    }
    
    func serverListDataModel(_ dataModel: ServerListDataModel, didFailWithError error: Error) {
        showErrorAlert(message: error.localizedDescription)
    }
}

// MARK: -

extension ServerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataModel.data[indexPath.row].cellInstance(in: tableView)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataModel.data[indexPath.row].cellHeight
    }
}
