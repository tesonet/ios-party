import UIKit

class ServersListViewController: UIViewController {
    @IBOutlet weak var tablView: UITableView!
    
    // MARK: - Actions
    @IBAction func logoutButtonTapped() {
        TokenService.removeToken()
        dismiss(animated: true, completion: nil)
    }
}
