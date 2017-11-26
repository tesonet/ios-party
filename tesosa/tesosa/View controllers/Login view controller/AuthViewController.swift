import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let serversListViewController = ServersListViewController()
    
    // MARK: - View life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        presentServersListIfPossible()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped() {
        
    }
    
    // MARK: - private
    
    private func presentServersListIfPossible() {
        if TokenService.token() != nil {
            present(serversListViewController, animated: false, completion: nil)
        }
    }
}
