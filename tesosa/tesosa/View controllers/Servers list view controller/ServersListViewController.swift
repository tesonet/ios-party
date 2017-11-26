import UIKit

class ServersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = ServerListDataSource()
    let apiService = APIService()
    let loaderController = LoaderViewController()
    var appearingFirstTime = true
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appearingFirstTime {
            appearingFirstTime = false
            loadData()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logoutButtonTapped() {
        TokenService.removeToken()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.register(UINib(nibName: ServerCellIdentifier, bundle: nil), forCellReuseIdentifier: ServerCellIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadData() {
        loaderController.modalPresentationStyle = .custom
        loaderController.modalTransitionStyle = .crossDissolve
        present(loaderController, animated: true, completion: nil)
        apiService.fetchServers(
            success: { [weak self] servers in
                self?.loaderController.dismiss(animated: true, completion: nil)
                self?.dataSource.update(serversDTO: servers)
                self?.tableView.reloadData()
            },
            failure: { [weak self] error in
                self?.loaderController.dismiss(animated: true, completion: nil)
                UIAlertController.presentErrorAlert(error: error)
            }
        )
    }
}
