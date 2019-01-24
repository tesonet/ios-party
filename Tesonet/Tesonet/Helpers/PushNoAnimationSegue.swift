import UIKit

/// Move to the next screen without an animation.
class PushNoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let dest: UIViewController = self.destination
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = dest
    }
}
