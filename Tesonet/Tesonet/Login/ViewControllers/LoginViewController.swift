import UIKit

class LoginViewController: UIViewController {
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    fileprivate var loginViewModel: LoginViewModelType =
        LoginViewModel(loginInteractor: LoginDependanciesProvider.shared.getLoginInteractor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLogin()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
}

// MARK: - Navigation

extension LoginViewController {
    @IBAction fileprivate func loginPressed() {
        #if DEBUG
        let username = "tesonet"
        let password = "partyanimal"
        #else
        let username = params.username ?? ""
        let password = params.password ?? ""
        #endif
        
        let loginData = LoginData(username: username, password: password)
        loginViewModel.retrieveToken(with: loginData)
    }
}

// MARK: - LoginViewControllerDelegate

extension LoginViewController: LoginViewControllerDelegate {
    func handleLoginError(error: Error) {
        if let responseStatusCodeError = error as? HTTPError {
            let allertTitle = "Error"
            let allertMeassage = "Login Error\n" + responseStatusCodeError.statusCode + ": " + responseStatusCodeError.description
            self.presentSimpleAlert(title: allertTitle, message: allertMeassage) {
                self.passwordTextField.text = nil
            }
        }
    }
    
    func moveToServersList() {
        self.performSegue(withIdentifier: "SegueToServers", sender: self)
    }
}

// MARK: - Privates

extension LoginViewController {
    fileprivate func setupLogin() {
        if UserSession.shared.isCrudentialsSaved {
            usernameTextField.text = UserSession.shared.signInDetails?.username
            passwordTextField.text = UserSession.shared.signInDetails?.password
        }
    }
}
