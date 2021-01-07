
import UIKit


protocol ServersViewControllerDelegate: class {
    
    func serversViewControllerDidLogout(_ serversViewController: ServersViewController)
}


class ServersViewController: UIViewController {

    
    // MARK: - Init
    static func make(dataModel: ServersDataModel) -> ServersViewController {
        let controller = ServersViewController()
        controller.dataModel = dataModel
        return controller
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var servers: [Server] = []
    
    private var dataModel: ServersDataModel!
    
    weak var delegate: ServersViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(dataModel != nil, "Data model must not be nil")
        dataModel.presenter = self
        setupNavigationBar()
        setupTableView()
        dataModel.fetchServers()
    }
}


// MARK: - ServersPresenter
extension ServersViewController: ServersPresenter {
    
    func presentServers(_ servers: [Server]) {
        self.servers = servers
        tableView.reloadData()
    }
    
    func presentError(_ error: Error) {
        showErrorAlert()
    }
}


// MARK: - UITableViewDataSource
extension ServersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.id,
                                                 for: indexPath) as! ServerTableViewCell
        cell.server = servers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return "SERVER"
    }
}


// MARK: - Private
private extension ServersViewController {
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Check your internet connection",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Try again",
                                      style: .default,
                                      handler: { [weak self] _ in
                                        self?.dataModel.fetchServers()}
        ))
        present(alert, animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        let image = UIImage(named: "ico-logout")?.withRenderingMode(.alwaysOriginal)
        let logoutItem = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(logoutClicked))
        navigationItem.rightBarButtonItem = logoutItem
        
        let logoImageView = UIImageView(image: UIImage(named: "logo-dark"))
        logoImageView.contentMode = .scaleAspectFit
        let logoItem = UIBarButtonItem(customView: logoImageView)
        logoItem.customView?.widthAnchor.constraint(equalToConstant: 70).isActive = true
        logoItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        navigationItem.leftBarButtonItem = logoItem
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.register(ServerTableViewCell.nib,
                           forCellReuseIdentifier: ServerTableViewCell.id)
    }
    
    @objc func logoutClicked() {
        dataModel.logout()
        delegate?.serversViewControllerDidLogout(self)
    }
}
