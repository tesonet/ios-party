import UIKit

enum ServersSortingType {
    case distance
    case name
}

class ServersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = ServerListDataSource()
    let apiService = APIService()
    let loaderController = LoaderViewController()
    var appearingFirstTime = true
    var selectedSorting: ServersSortingType = .distance
    var servers = [Server]()
    
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
        KeychainService.deleteToken()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortButtonTapped() {
        presentSortingOptions()
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.register(UINib(nibName: ServerCellIdentifier, bundle: nil), forCellReuseIdentifier: ServerCellIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func presentSortingOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(alertAction(titleKey: "sort_by_distance_button_title", style: .default, type: .distance))
        alertController.addAction(alertAction(titleKey: "sort_by_name", style: .default, type: .name))
        alertController.addAction(alertAction(titleKey: "cancel_button_title", style: .cancel))
        present(alertController, animated: true, completion: nil)
    }
    
    private func alertAction(titleKey: String, style: UIAlertActionStyle, type: ServersSortingType? = nil) -> UIAlertAction {
        return UIAlertAction(
            title: LocalizationService.localized(key: titleKey),
            style: style,
            handler: { [weak self] _ in
                if let type = type {
                    self?.selectedSorting = type
                    self?.updateList()
                }
                
            }
        )
    }
    
    private func loadData() {
        loaderController.modalPresentationStyle = .custom
        loaderController.modalTransitionStyle = .crossDissolve
        present(loaderController, animated: true, completion: nil)
        apiService.fetchServers(
            success: { [weak self] serversDTO in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.loaderController.dismiss(animated: true, completion: nil)
                strongSelf.servers = serversDTO.servers
                strongSelf.updateList()
            },
            failure: { [weak self] error in
                self?.loaderController.dismiss(animated: true, completion: nil)
                UIAlertController.presentErrorAlert(error: error)
            }
        )
    }
    
    private func updateList() {
        dataSource.update(fetchedServers: servers, sorting: selectedSorting)
        tableView.reloadData()
    }
}
