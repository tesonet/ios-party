//
//  ServerListViewController+TableView.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import UIKit

extension ServerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: ServerListTableViewCell =
            tableView.dequeueReusableCellWithClass(ServerListTableViewCell.self) as? ServerListTableViewCell else {
            print("WARNING! Could not dequeue `ServerListTableViewCell` from table view.")
            return UITableViewCell()
        }
        
        cell.populate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCellWithClass(HeaderTableViewCell.self) as? HeaderTableViewCell else {
            return nil
        }
        
        cell.populate(serverTitle: Constants.serverHeaderTitle, distanceTitle: Constants.distanceHeaderTitle)
        return cell
    }
}
