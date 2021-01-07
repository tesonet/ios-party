
import UIKit


class SessionViewController: UIViewController {
    
    private var currentController: UIViewController?
    private var screenFactory: ScreenFactory!
    
    var sessionContext: SessionContext!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenFactory = makeScreenFactory(with: sessionContext)
        setup()
    }
}


// MARK: - LoginViewControllerDelegate
extension SessionViewController: LoginViewControllerDelegate {
    
    func loginViewControllerDidLogin(_ loginViewController: LoginViewController) {
        showServers()
    }
}


// MARK: - ServersViewControllerDelegate
extension SessionViewController: ServersViewControllerDelegate {
    
    func serversViewControllerDidLogout(_ serversViewController: ServersViewController) {
        showLogin()
    }
}


// MARK: - Private
private extension SessionViewController {
    
    func setup() {
        if sessionContext.session.isActive {
            showServers()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let login = screenFactory.makeLoginScreen()
        login.delegate = self
        setController(login)
    }
    
    func showServers() {
        let servers = screenFactory.makeServersScreen()
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
