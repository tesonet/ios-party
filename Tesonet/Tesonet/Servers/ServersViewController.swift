import UIKit

class ServersViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!

    var username: String!
    var password: String!
    var serversList = [Server]() {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ServersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serversList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return serverCell(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        let headerView = ServersTableHeaderView.loadFromNib()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        let footerView = ServersTableFooterView.loadFromNib()
        footerView.delegate = self
        return footerView
    }
    
    fileprivate func serverCell(atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell", for: indexPath) as? ServersTableCell else {
            fatalError("Could not dequeue cell of type ServerCell")
        }
        let server = serversList[indexPath.row]
        cell.configure(with: server)
        return cell
    }
    
}

// MARK: ServersTableFooterDelegate

extension ServersViewController: ServersTableFooterDelegate {
    
    func sortWasPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let distanceSortButton = UIAlertAction(title: "By Distance", style: .default) { _ in
            self.serversList = self.serversList.sorted(by: { $0.distance < $1.distance })
        }
        let  alphanumericalSortButton = UIAlertAction(title: "Alphanumerical", style: .default) { _ in
            self.serversList = self.serversList.sorted(by: { $0.name < $1.name })
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(distanceSortButton)
        alertController.addAction(alphanumericalSortButton)
        alertController.addAction(cancelButton)
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: Private Methods

extension ServersViewController {
    
    fileprivate func fetchData() {
        DownloadManager.shared.requestToken(from: URLs.Tesonet.tokenURL, withParams: ["username": username, "password": password]) { result, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let token = result else {
                return
            }
            
            DownloadManager.shared.requestServersData(from: URLs.Tesonet.dataURL, with: token) { [weak self] result, error in
                guard let `self` = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                
                guard let result = result else {
                    return
                }
                
                self.serversList = result
                
                //self.save(data: result, using: .userDefaultsPersistance)
            }
        }
    }
    
    fileprivate func save(data: [Server], using persistanceType: PersistanceType) {
        let userDefaultsPersistance = PersistanceFactory.producePersistanceType(type: persistanceType)
        userDefaultsPersistance.write(servers: data)
    }
    
}
