import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    fileprivate var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension LoginViewController: SegueHandler {
    
    @IBAction fileprivate func loginPressed() {
        #if DEBUG
        let username = "tesonet"
        let password = "partyanimal"
        #else
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        #endif
        
        DownloadManager.shared.loadToken(from: URLs.Tesonet.tokenURL, withParams: ["username": username, "password": password]) { [weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                self.print(items: error)
                DispatchQueue.main.async {
                    self.handleLoginError(error: error)
                }
                return
            }
            
            guard let accessToken = result else {
                return
            }
            
            self.accessToken = accessToken
            self.saveSession(accessToken: accessToken, username: username, password: password)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SegueToServers", sender: self)
            }
        }
    }

    enum SegueIdentifier: String {
        case
        SegueToServers
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch identifierForSegue(segue: segue) {
        case .SegueToServers:
            if let destination = segue.destination as? UINavigationController,
                let serversViewController = destination.topViewController as? ServersViewController {
                serversViewController.accessToken = UserSession.shared.token!
            }
        }
    }
    
}



// MARK: - Private Methods

extension LoginViewController {
    
    fileprivate func setupLogin() {
        if UserSession.shared.isCrudentialsSaved() {
            usernameTextField.text = UserSession.shared.signInDetails?.username
            passwordTextField.text = UserSession.shared.signInDetails?.password
        }
    }
    
    fileprivate func saveSession(accessToken: String, username: String, password: String) {
        UserSession.shared.save(token: accessToken, username: username, password: password)
    }
    
    fileprivate func handleLoginError(error: Error) {
        if let responseStatusCodeError = error as? HTTPError {
            let allertTitle = "Error"
            let allertMeassage = "Login Error\n" + responseStatusCodeError.statusCode + ": " + responseStatusCodeError.description
            self.presentSimpleAlert(title: allertTitle, message: allertMeassage) {
                self.passwordTextField.text = nil
            }
        }
    }
    
}
