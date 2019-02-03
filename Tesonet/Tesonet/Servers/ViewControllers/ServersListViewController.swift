import UIKit

class ServersListViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var serversViewModel =
        ServersViewModel(serversListInteractor: ServersDependanciesProvider.shared.getListInteractor())
    
    // Gere we create header/footer which you we hide/show anytime
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
        serversViewModel.delegate = self
        serversViewModel.retrieveAllServers()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ServersListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serversViewModel.serversList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return serverCell(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServersListTableCell",
                                                       for: indexPath) as? ServersListTableCell else {
            fatalError("Could not dequeue cell of type ServerCell")
        }
        let server = serversViewModel.serversList[indexPath.row]
        cell.configure(with: server)
        return cell
    }
}

// MARK: - ViewModelDelegate

extension ServersListViewController: ServersListViewControllerDelegate {
    func serversListDidChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - ServersTableFooterDelegate

extension ServersListViewController: ServersTableFooterDelegate {
    func sortWasPressed() {
        footerView.isHidden = true
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let distanceSortButton = UIAlertAction(title: "By Distance", style: .default) { [unowned self] _ in
            self.footerView.isHidden = false
            self.serversViewModel.serversList = self.serversViewModel.serversList.sorted(by: {
                $0.distance ?? -1 < $1.distance ?? -1
            })
        }
        let  alphanumericalSortButton = UIAlertAction(title: "Alphanumerical", style: .default) { [unowned self] _ in
            self.footerView.isHidden = false
            self.serversViewModel.serversList = self.serversViewModel.serversList.sorted(by: {
                $0.name ?? "Error" < $1.name ?? "Error"
            })
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

extension ServersListViewController {
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

// MARK: - Privates

extension ServersListViewController {
    fileprivate func signOut(forgetLogin: Bool) {
        UserSession.shared.signOut(forgetLogin: forgetLogin)
        self.performSegue(withIdentifier: "SequeToLogin", sender: self)
    }
}
