//
//  ServerListViewController+TableView.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

extension ServerListViewController {
    
    // MARK: - Methods
    func registerTableViewCells() {
        tableView.registerCellNib(withType: ServerCell.self)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.serverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let server = dataModel.serverList[safe: indexPath.row] else {
            log("ERROR! Could not get server for server row: \(indexPath.row)")
            return UITableViewCell()
        }
        
        return cellForServer(server)
    }
    
    func cellForServer(_ server: ServerEntity) -> UITableViewCell {
        guard let cell: ServerCell = tableView.dequeueReusableCell() else {
            log("ERROR! Could not dequeue ServerCell")
            return UITableViewCell()
        }
        
        cell.populate(withServer: server)
        return cell
    }
}
