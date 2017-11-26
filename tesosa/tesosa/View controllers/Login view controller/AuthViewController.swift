import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let authorizationService = APIService()
    
    // MARK: - View life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        presentServersListIfPossible()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped() {
        authorize()
    }
    
    // MARK: - private
    
    private func authorize() {
        authorizationService.authorize(
            username: usernameTextField.text ?? "",
            password: passwordTextField.text ?? "",
            success: { [weak self] authorization in
                TokenService.saveToken(token: authorization.token)
                self?.presentServersListIfPossible()
            },
            failure: { error in
                UIAlertController.presentErrorAlert(error: error)
            }
        )
    }
    
    private func presentServersListIfPossible() {
        if TokenService.token() != nil {
            present(ServersListViewController(), animated: false, completion: nil)
        }
    }
}
