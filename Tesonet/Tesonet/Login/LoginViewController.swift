import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    fileprivate var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

// MARK: - IBActions

extension LoginViewController {
    
    @IBAction fileprivate func loginPressed() {
        let username = "tesonet" // usernameTextField.text
        let password = "partyanimal" // passwordTextField.text
        
        DownloadManager.shared.requestToken(from: URLs.Tesonet.tokenURL, withParams: ["username": username, "password": password]) { [weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
                return
            }
            
            guard let accessToken = result else {
                return
            }
            
            self.accessToken = accessToken
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SegueToServers", sender: self)
            }
        }
    }
}

// MARK: - Navigation

extension LoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToServers" {
            if let serversViewController = segue.destination as? ServersViewController {
                serversViewController.accessToken = accessToken!
            }
        }
    }
    
}

// MARK: Private Methods

extension LoginViewController {
    
    fileprivate func style() {
        
    }
    
}
