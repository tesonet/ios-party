
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
        #warning("TODO: Show content screen")
    }
}


private extension SessionViewController {
    
    func setup() {
        let login = screenFactory.createLogin()
        login.delegate = self
        setController(login)
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
