
import UIKit


protocol ServersViewControllerDelegate: class {
    
    func serversViewControllerDidLogout(_ serversViewController: ServersViewController)
}


class ServersViewController: UIViewController {

    static func createWithFacade(_ facade: ServersFacade) -> ServersViewController {
        let controller = ServersViewController()
        controller.facade = facade
        return controller
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var servers: [Server] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var facade: ServersFacade!
    
    weak var delegate: ServersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(facade != nil, "Facade must not be nil")
        setupNavigationBar()
        setupTableView()
        fetchServers()
    }
}


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


private extension ServersViewController {
    
    func fetchServers() {
        facade.servers()
            .done { [weak self] servers in
                self?.servers = servers
            }
            .catch { [weak self] error in
                self?.showErrorAlert()
        }
    }
    
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
                                        self?.fetchServers()}
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
        facade.logout()
        delegate?.serversViewControllerDidLogout(self)
    }
}
