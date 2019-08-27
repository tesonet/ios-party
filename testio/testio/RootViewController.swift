
import UIKit


class RootViewController: UIViewController {
    
    private var currentController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


private extension RootViewController {
    
    func setup() {
        setController(ViewController())
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
