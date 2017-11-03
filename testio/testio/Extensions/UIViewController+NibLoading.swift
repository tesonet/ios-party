import UIKit

extension UIViewController {
    static func initWithNib() -> Self {
        let className = NSStringFromClass(self).components(separatedBy: ".").last
        let bundle = Bundle(for: self)
        return self.init(nibName: className, bundle: bundle)
    }
}
