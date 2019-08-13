import UIKit

public let kDefaultPushTransitionType: CATransitionType = CATransitionType.fade
public let kDefaultPopTransitionType: CATransitionType = CATransitionType.fade
public let kDefaultNavigatorTransitionDuration: CFTimeInterval = 0.3

public extension UINavigationController {
    func push(_ ctrl: UIViewController, transitionType type: CATransitionType = kDefaultPushTransitionType, duration: CFTimeInterval = kDefaultNavigatorTransitionDuration) {
        self.addPushTransition(transitionType: type, duration: duration)
        self.pushViewController(ctrl, animated: false)
    }

	func pop(transitionType type: CATransitionType = kDefaultPopTransitionType, duration: CFTimeInterval = kDefaultNavigatorTransitionDuration) {
		self.addPopTransition(transitionType: type, duration: duration)
		self.popViewController(animated: false)
	}
	
	private func addPushTransition(transitionType type: CATransitionType, duration: CFTimeInterval) {
		let transition = CATransition()
		transition.duration = duration
		transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		transition.type = type
		//transition.subtype = .fromRight
		self.view.layer.add(transition, forKey: nil)
	}

	private func addPopTransition(transitionType type: CATransitionType, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
		//transition.subtype = .fromLeft
        self.view.layer.add(transition, forKey: nil)
    }
}
