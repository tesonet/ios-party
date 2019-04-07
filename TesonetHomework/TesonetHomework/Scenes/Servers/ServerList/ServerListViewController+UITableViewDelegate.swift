// Created by Paulius Cesekas on 07/04/2019.

import UIKit

extension ServerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = tableViewDataSource.tableSection(atIndex: section) else {
            return CGFloat.leastNonzeroMagnitude
        }
        
        switch section {
        case .servers:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = tableViewDataSource.tableSection(atIndex: section) else {
            return nil
        }
        
        switch section {
        case .servers:
            return ServerListHeader.header(in: tableView)
        }
    }

}
