import UIKit

class LoginNavigationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveToNextScreen()
    }
}

// MARK: - Navigation

extension LoginNavigationViewController: SegueHandler {
    enum SegueIdentifier: String {
        case
        SegueNavigationToServers
        case
        SegueNavigationToLogin
    }

    fileprivate func moveToNextScreen() {
        if UserSession.shared.isLogedIn {
            self.performSegueWithIdentifier(identifier: .SegueNavigationToServers, sender: self)
        } else {
            self.performSegueWithIdentifier(identifier: .SegueNavigationToLogin, sender: self)
        }
    }
}

