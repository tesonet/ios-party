import UIKit

extension ActivityIndicating where Self: UIViewController {
    
    func showActivityIndicator() {
        let activityView = ActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityView)
        NSLayoutConstraint.fill(view: view, with: activityView)
    }
    
    func hideActivityIndicator() {
        let activityView = view.subviews.first { $0 is ActivityIndicatorView }
        activityView?.removeFromSuperview()
    }
}
