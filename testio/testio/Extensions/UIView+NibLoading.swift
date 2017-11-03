import UIKit

extension UIView {
    class func nib() -> UINib {
        let nibName = "\(self)".characters.split {$0 == "."}.map(String.init).last!
        return UINib(nibName: nibName, bundle: nil)
    }
}

protocol UIViewLoading {}

extension UIView: UIViewLoading {}

extension UIViewLoading where Self: UIView {
    static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        let nibName = nibNameOrNil ?? self.className
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }

    static private var className: String {
        let className = "\(self)"
        let components = className.characters.split { $0 == "." }.map(String.init)
        return components.last!
    }
}
