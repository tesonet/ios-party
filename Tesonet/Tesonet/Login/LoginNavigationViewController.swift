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

extension LoginNavigationViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueNavigationToServers" {
            let destinationNavigationController = segue.destination as! UINavigationController
            if let serversViewController = destinationNavigationController.topViewController as? ServersViewController {
                serversViewController.accessToken = UserSession.shared.token!
            }
        }
    }
    
}

// MARK: - Private Methods

extension LoginNavigationViewController {

    fileprivate func moveToNextScreen() {
        if UserSession.shared.isLogedIn() {
            self.performSegue(withIdentifier: "SegueNavigationToServers", sender: self)
        } else {
            self.performSegue(withIdentifier: "SegueNavigationToLogin", sender: self)
        }
    }
    
}

