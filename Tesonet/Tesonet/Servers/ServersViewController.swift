import UIKit

class ServersViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var serversList = [Server]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    fileprivate lazy var footerView: ServersTableFooterView = {
        let footerView = ServersTableFooterView.loadFromNib()
        footerView.delegate = self
        return footerView
    }()
    fileprivate lazy var headerView: ServersTableHeaderView = {
        let headerView = ServersTableHeaderView.loadFromNib()
        return headerView
    }()
    
    
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
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
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

// MARK: - ServersTableFooterDelegate

extension ServersViewController: ServersTableFooterDelegate {
    
    func sortWasPressed() {
        footerView.isHidden = true
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let distanceSortButton = UIAlertAction(title: "By Distance", style: .default) { [unowned self] _ in
            self.footerView.isHidden = false
            self.serversList = self.serversList.sorted(by: { $0.distance < $1.distance })
        }
        let  alphanumericalSortButton = UIAlertAction(title: "Alphanumerical", style: .default) { [unowned self] _ in
            self.footerView.isHidden = false
            self.serversList = self.serversList.sorted(by: { $0.name < $1.name })
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
            self.footerView.isHidden = false
        }
        alertController.addAction(distanceSortButton)
        alertController.addAction(alphanumericalSortButton)
        alertController.addAction(cancelButton)
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Navigation

extension ServersViewController {
    
    @IBAction fileprivate func logoutPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Sign out",
                                                message: "Are you sure you want to sign out?",
                                                preferredStyle: .actionSheet)
        let signOutButton = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            self.signOut(forgetLogin: false)
        }
        let  signOutAndForgetButton = UIAlertAction(title: "Yes and forget sign-in details", style: .default) { [unowned self] _ in
            self.signOut(forgetLogin: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(signOutButton)
        alertController.addAction(signOutAndForgetButton)
        alertController.addAction(cancelButton)
        navigationController?.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Private Methods

extension ServersViewController {
    
    fileprivate func fetchData() {
        guard let accessToken = UserSession.shared.token else {
            return
        }
        DownloadManager.shared.loadData(from: URLs.Tesonet.dataURL, with: accessToken) { [weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                self.print(items: error)
                return
            }
            
            guard let result = result else {
                return
            }
            
            self.serversList = result
            
            self.save(data: result, using: .filePersistance)
        }
    }
    
    fileprivate func save(data: [Server], using persistanceType: PersistanceType) {
        let persistance = PersistanceFactory.producePersistanceType(type: persistanceType)
        persistance.write(items: data)
        #if DEBUG
        let servers = persistance.read() as [Server]
        self.print(items: servers)
        #endif
    }
    
    fileprivate func signOut(forgetLogin: Bool) {
        UserSession.shared.signOut(forgetLogin: forgetLogin)
        self.performSegue(withIdentifier: "SequeToLogin", sender: self)
    }
    
}
