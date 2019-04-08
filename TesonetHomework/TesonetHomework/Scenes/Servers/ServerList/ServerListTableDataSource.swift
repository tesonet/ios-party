// Created by Paulius Cesekas on 06/04/2019.

import UIKit
import Domain

class ServerListTableDataSource: NSObject {
    enum Section {
        case servers
    }
    enum Row {
        case server(_ server: Server)
    }
    
    // MARK: - Constants
    private let footerHeight: CGFloat = 44
    
    // MARK: - Variables
    var tableSections: [Section] = [.servers]
    var servers: [Server]?

    // MARK: - Methods -
    init(_ tableView: UITableView) {
        super.init()
        configureCells(for: tableView)
        configureHeadersFooters(for: tableView)
    }
    
    // MARK: - Setup
    private func configureCells(for tableView: UITableView) {
        tableView.register(
            UINib(
                nibName: ServerListCell.typeName,
                bundle: Bundle.main),
            forCellReuseIdentifier: ServerListCell.typeName)
    }
    
    private func configureHeadersFooters(for tableView: UITableView) {
        tableView.register(
            UINib(
                nibName: ServerListHeader.typeName,
                bundle: Bundle.main),
            forHeaderFooterViewReuseIdentifier: ServerListHeader.typeName)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = ServerListHeader.height
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: footerHeight)
    }
    
    // MARK: - Helpers
    func tableSection(atIndex index: Int) -> Section? {
        guard tableSections.count > index else {
            return nil
        }
        
        return tableSections[index]
    }
    
    private func tableRow(at indexPath: IndexPath) -> Row? {
        guard let section = tableSection(atIndex: indexPath.section) else {
            return nil
        }
        
        switch section {
        case .servers:
            guard let servers = servers,
                servers.count > indexPath.row else {
                    return nil
            }
            
            return .server(servers[indexPath.row])
        }
    }
}

// MARK: - UITableViewDataSource
extension ServerListTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = tableSection(atIndex: section) else {
            return 0
        }
        
        switch section {
        case .servers:
            return servers?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = tableRow(at: indexPath) else {
            return UITableViewCell()
        }
        
        switch row {
        case .server(let server):
            return ServerListCell.cell(
                in: tableView,
                for: indexPath,
                with: ServerListCell.Config(server: server))
        }
    }
}
