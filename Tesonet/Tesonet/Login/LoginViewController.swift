import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

// MARK: - IBActions

extension LoginViewController {
    
    @IBAction fileprivate func loginPressed() {
        self.performSegue(withIdentifier: "SegueToServers", sender: self)
    }
    
}

// MARK: - Navigation

extension LoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToServers" {
            if let serversViewController = segue.destination as? ServersViewController {
                serversViewController.username =  "tesonet" // passwordTextField.text
                serversViewController.password =  "partyanimal" // passwordTextField.text
            }
        }
    }
    
}

// MARK: Private Methods

extension LoginViewController {
    
    fileprivate func style() {
        
    }
    
}
