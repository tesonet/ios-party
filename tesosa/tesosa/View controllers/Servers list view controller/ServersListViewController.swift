import UIKit

class ServersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = ServerListDataSource()
    let apiService = APIService()
    let loaderController = LoaderViewController()
    var appearingFirstTime = true
    
    // MARK: - View life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        if appearingFirstTime {
            appearingFirstTime = false
            loaderController.modalPresentationStyle = .custom
            loaderController.modalTransitionStyle = .crossDissolve
            present(loaderController, animated: true, completion: nil)
            apiService.fetchServers(
                success: { [weak self] servers in
                    self?.loaderController.dismiss(animated: true, completion: nil)
                },
                failure: { [weak self] error in
                    self?.loaderController.dismiss(animated: true, completion: nil)
                    UIAlertController.presentErrorAlert(error: error)
                }
            )
        }
        
    }
    
    // MARK: - Actions
    @IBAction func logoutButtonTapped() {
        TokenService.removeToken()
        dismiss(animated: true, completion: nil)
    }
}
