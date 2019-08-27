

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func loginButtonClicked(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let passsword = passwordTextField.text ?? ""
        
        guard !username.isEmpty && !passsword.isEmpty else {
            return
        }
        
        #warning("Implement login through API")
    }
}
