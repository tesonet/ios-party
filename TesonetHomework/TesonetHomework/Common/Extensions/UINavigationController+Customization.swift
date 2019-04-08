// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UINavigationController {
    enum NavigationBarSide: Int {
        case left
        case right
    }
    
    // MARK: - Methods -
    func applyDefaultStyle() {
        view.backgroundColor = UIColor.NavigationBar.background
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor.NavigationBar.background
        navigationBar.tintColor = UIColor.NavigationBar.foreground
        navigationBar.isTranslucent = true
        navigationBar.clipsToBounds = false
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    @discardableResult
    func addButton(with image: UIImage,
                   to navigationBarSide: NavigationBarSide,
                   target: Any?,
                   action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = UIColor.NavigationBar.foreground
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        let width = image.size.width > Constants.navigationBarButtonMinSize.width ?
            image.size.width :
            Constants.navigationBarButtonMinSize.width
        let height = image.size.height > Constants.navigationBarButtonMinSize.height ?
            image.size.height :
            Constants.navigationBarButtonMinSize.height
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        let padding = image.size.width - width
        button.addTarget(
            target,
            action: action,
            for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        switch navigationBarSide {
        case .left:
            button.imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: padding,
                bottom: 0,
                right: 0)
            navigationBar.topItem?.leftBarButtonItem = barButtonItem
        case .right:
            button.imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: padding)
            navigationBar.topItem?.rightBarButtonItem = barButtonItem
        }
        return barButtonItem
    }

}
