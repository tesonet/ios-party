
import UIKit


class SessionViewController: UIViewController {
    
    private var currentController: UIViewController?
    private var screenFactory: ScreenFactory!
    
    var sessionContext: SessionContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenFactory = createScreenFactory(with: sessionContext)
        setup()
    }
}


extension SessionViewController: LoginViewControllerDelegate {
    
    func loginViewControllerDidLogin(_ loginViewController: LoginViewController) {
        showServers()
    }
}


extension SessionViewController: ServersViewControllerDelegate {
    
    func serversViewControllerDidLogout(_ serversViewController: ServersViewController) {
        showLogin()
    }
}


private extension SessionViewController {
    
    func setup() {
        if sessionContext.session.isActive {
            showServers()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let login = screenFactory.createLogin()
        login.delegate = self
        setController(login)
    }
    
    func showServers() {
        let servers = screenFactory.createServers()
        servers.delegate = self
        let serversNav = UINavigationController(rootViewController: servers)
        setController(serversNav)
    }
    
    func setController(_ controller: UIViewController) {
        dismiss(animated: false, completion: nil)
        currentController?.removeFromParent()
        currentController?.view.removeFromSuperview()
        
        controller.willMove(toParent: self)
        addChild(controller)
        
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                           options: .directionLeadingToTrailing,
                                                           metrics: nil,
                                                           views: ["view": controller.view!]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                           options: .directionLeadingToTrailing,
                                                           metrics: nil,
                                                           views: ["view": controller.view!]))
        controller.didMove(toParent: self)
        
        currentController = controller
    }
}
