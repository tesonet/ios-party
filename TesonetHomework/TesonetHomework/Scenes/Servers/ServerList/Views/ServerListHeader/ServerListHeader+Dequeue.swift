// Created by Paulius Cesekas on 06/04/2019.

import UIKit
import Domain

extension ServerListHeader {
    static func header(in tableView: UITableView) -> UITableViewHeaderFooterView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ServerListHeader.typeName) as? ServerListHeader else {
                return nil
        }

        return headerView
    }
}
