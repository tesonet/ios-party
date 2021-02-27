//
//  ListDataSource.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

protocol ListDataSourceDelegate: AnyObject {
    func dataSourceDidUpdate(error: APIClientError?)
}

final class ListDataSource: NSObject {
    
    var servers: [Server]? = ListStorage.load()
    
    weak var delegate: ListDataSourceDelegate?
    
    init(delegate: ListDataSourceDelegate) {
        self.delegate = delegate
    }
    
    func update() {
        ListService().list { [weak self] (result) in
            switch result {
            case .success(let success):
                self?.servers = success
                ListStorage.update(servers: success)
                self?.delegate?.dataSourceDidUpdate(error: nil)
            case .failure(let error):
                self?.delegate?.dataSourceDidUpdate(error: error)
            }
        }
    }
}

// MARK: - Sorting
extension ListDataSource {
    enum ServerSort {
        case distance
        case alphanumerical
    }
    
    func sort(by sort: ServerSort) {
        switch sort {
        case .distance:
            servers = servers?.sorted(by: { $0.distance ?? 0 <= $1.distance ?? 0 })
        case .alphanumerical:
            servers = servers?.sorted(by: { $0.name?.caseInsensitiveCompare($1.name ?? "") == .orderedAscending })
        }
    }
}

// MARK - UITableView DataSource
extension ListDataSource: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        servers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServerTableViewCell
        guard let server = servers?[indexPath.row] else { return cell }
        let viewModel = ServerViewModel(server: server)
        cell.nameLabel.text = viewModel.name
        cell.distanceLabel.text = viewModel.distance
        return cell
    }
}
