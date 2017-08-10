import UIKit

extension UIView {
    func roundCorners(by radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}
