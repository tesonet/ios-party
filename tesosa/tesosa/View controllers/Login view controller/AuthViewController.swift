import UIKit
import QuartzCore

class AuthViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let authorizationService = APIService()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        setupViews()
    }
    
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
                KeychainService.save(token: authorization.token)
                self?.presentServersListIfPossible()
            },
            failure: { error in
                UIAlertController.presentErrorAlert(error: error)
            }
        )
    }
    
    private func presentServersListIfPossible() {
        if KeychainService.token() != nil {
            present(ServersListViewController(), animated: false, completion: nil)
        }
    }
    
    private func setupViews() {
        usernameTextField.placeholder = LocalizationService.localized(key: "username_input_placeholder")
        passwordTextField.placeholder = LocalizationService.localized(key: "password_input_placeholder")
        loginButton.setTitle(LocalizationService.localized(key: "login_button_title"), for: .normal)
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
