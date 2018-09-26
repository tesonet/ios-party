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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch identifierForSegue(segue: segue) {
        case .SegueNavigationToServers:
            if let destination = segue.destination as? UINavigationController,
                let serversViewController = destination.topViewController as? ServersViewController {
                serversViewController.accessToken = UserSession.shared.token!
            }
        default:
            break
        }
    }
    
}

// MARK: - Private Methods

extension LoginNavigationViewController {

    fileprivate func moveToNextScreen() {
        if UserSession.shared.isLogedIn() {
            self.performSegueWithIdentifier(identifier: .SegueNavigationToServers, sender: self)
        } else {
            self.performSegueWithIdentifier(identifier: .SegueNavigationToLogin, sender: self)
        }
    }
    
}

