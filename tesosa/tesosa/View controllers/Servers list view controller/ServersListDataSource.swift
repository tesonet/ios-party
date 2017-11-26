import UIKit

let ServerCellIdentifier = "ServerCell"

class ServerListDataSource: NSObject, UITableViewDataSource {
    private var servers = [Server]()
    
    func update(serversDTO: Servers) {
        servers = serversDTO.servers
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerCellIdentifier, for: indexPath) as? ServerCell,
            servers.count > indexPath.row else {
                assertionFailure("Servers list data source setup wrong")
                return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        cell.update(server: servers[indexPath.row])
        return cell
    }
}
