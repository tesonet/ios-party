

import UIKit


protocol LoginViewControllerDelegate: class {
    
    func loginViewControllerDidLogin(_ loginViewController: LoginViewController)
}


class LoginViewController: UIViewController {

    
    // MARK: - Init
    static func make(dataModel: LoginDataModel) -> LoginViewController {
        let controller = LoginViewController()
        controller.dataModel = dataModel
        return controller
    }
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    private var dataModel: LoginDataModel!
    
    weak var delegate: LoginViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(dataModel != nil, "Data model must not be nil")
        dataModel.presenter = self
        setupTextFields()
    }
    
    
    // MARK: - UI actions
    @IBAction private func loginButtonClicked(_ sender: Any) {
        login()
    }
}


// MARK: - LoginPresenter
extension LoginViewController: LoginPresenter {
    
    func presentSuccess() {
        delegate?.loginViewControllerDidLogin(self)
    }
    
    func presentError(_ error: Error) {
        showErrorAlert()
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
}


// MARK: - Private
private extension LoginViewController {
    
    func login() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        guard !username.isEmpty && !password.isEmpty else {
            return
        }
        
        dataModel.login(with: username,
                        password: password)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Check your credentials and internet connection",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
}
