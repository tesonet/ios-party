// Created by Paulius Cesekas on 07/04/2019.

import UIKit

extension ServerListViewController: UITableViewDelegate {
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
