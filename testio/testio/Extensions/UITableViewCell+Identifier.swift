import UIKit

extension UITableViewCell {
    class func reuseIdentifier() -> String {
        return NSStringFromClass(self)
    }
}
