

import UIKit


protocol LoginViewControllerDelegate: class {
    
    func loginViewControllerDidLogin(_ loginViewController: LoginViewController)
}


class LoginViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var facade: LoginFacade!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(facade != nil, "Facade must not be nil")
    }
    
    @IBAction private func loginButtonClicked(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let passsword = passwordTextField.text ?? ""
        
        guard !username.isEmpty && !passsword.isEmpty else {
            return
        }
        
        login(with: username,
              password: passsword)
    }
    
    private func login(with username: String, password: String) {
        facade
            .login(with: username,
                   password: password)
            .done { [unowned self] _ in
                self.delegate?.loginViewControllerDidLogin(self)
            }
            .catch { [unowned self] error in
                self.showErrorAlert()
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Check your credentials and internet connection",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
