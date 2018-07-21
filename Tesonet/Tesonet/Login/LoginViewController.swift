import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    fileprivate var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        style()
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

// MARK: - IBActions

extension LoginViewController {
    
    @IBAction fileprivate func loginPressed() {
        #if DEBUG
        let username = "tesonet"
        let password = "partyanimal"
        #else
        let username = usernameTextField.text
        let password = passwordTextField.text
        #endif
        
        DownloadManager.shared.loadToken(from: URLs.Tesonet.tokenURL, withParams: ["username": username, "password": password]) { [weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
                self.handleLoginError(error: error)
                return
            }
            
            guard let accessToken = result else {
                return
            }
            
            self.accessToken = accessToken
            self.saveSession(accessToken: accessToken, username: username, password: password)
            self.performSegue(withIdentifier: "SegueToServers", sender: self)
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
}

// MARK: - Navigation

extension LoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToServers" {
            let destinationNavigationController = segue.destination as! UINavigationController
            if let serversViewController = destinationNavigationController.topViewController as? ServersViewController {
                serversViewController.accessToken = accessToken!
            }
        }
    }
    
}

// MARK: Private Methods

extension LoginViewController {
    
    fileprivate func setupLogin() {
        if UserSession.shared.signInDetails != nil {
            usernameTextField.text = UserSession.shared.signInDetails?.username
            passwordTextField.text = UserSession.shared.signInDetails?.password
        }
    }
    
    fileprivate func saveSession(accessToken: String, username: String, password: String) {
        UserSession.shared.token = accessToken
        UserSession.shared.signInDetails = (username, password)
    }
    
    fileprivate func handleLoginError(error: Error) {
        if let responseStatusCodeError = error as? HTTPError {
            self.presentSimpleAlert(title: responseStatusCodeError.statusCode,
                                    message: responseStatusCodeError.description) {
                                        self.usernameTextField.text = nil
            }
        }
    }
    
    fileprivate func style() {
        
    }
    
}
