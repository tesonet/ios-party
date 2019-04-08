// Created by Paulius Cesekas on 06/04/2019.

import UIKit
import Domain

extension ServerListCell {
    struct Config {
        let server: Server
    }
    
    static func cell(in tableView: UITableView,
                     for indexPath: IndexPath,
                     with config: Config) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ServerListCell.typeName,
            for: indexPath) as? ServerListCell else {
                return UITableViewCell()
        }
        
        cell.populate(config.server)
        return cell
    }
}
