//
//  ServerListViewController+TableView.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

fileprivate let kTableViewSectionHeaderDefaultHeight: CGFloat = 55
fileprivate let kTableViewSectionHeaderDisabledHeight: CGFloat = .leastNormalMagnitude

extension ServerListViewController {
    
    // MARK: - Methods
    func registerTableViewCells() {
        tableView.registerCellNib(withType: ServerCell.self)
        tableView.registerHeaderFooterViewNib(withType: ServerListHeaderView.self)
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
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        guard let sectionType = UserDetailsSectionType(rawValue: section) else {
//            log("ERROR! Could not get UserDetailsSectionType with rawValue: \(section)")
//            return kTableViewSectionHeaderDisabledHeight
//        }
        
        return kTableViewSectionHeaderDefaultHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let sectionType = UserDetailsSectionType(rawValue: section) else {
//            log("ERROR! Could not get UserDetailsSectionType with rawValue: \(section)")
//            return nil
//        }
        
        return serverListHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kTableViewSectionHeaderDisabledHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func serverListHeaderView() -> UIView? {
        guard let headerView: ServerListHeaderView = tableView.dequeueReusableHeaderFooterView() else {
            log("ERROR! Could not dequeue ServerListHeaderView")
            return nil
        }
        
        return headerView
    }
}
