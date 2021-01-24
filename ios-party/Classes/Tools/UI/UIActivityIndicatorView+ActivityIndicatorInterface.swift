//
//  UIActivityIndicatorView+ActivityIndicatorInterface.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import UIKit
import PureLayout

protocol ActivityIndicatorInterface {
    func showInRootView()
    func show(inView view: UIView)
    func hide()
}

//
// Usage example:
// lazy var activityIndicator: ActivityIndicatorInterface = UIActivityIndicatorView(withPurpose: .standard)
//

fileprivate let kBackgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)

extension UIActivityIndicatorView: ActivityIndicatorInterface {
    
    enum CustomStyle {
        case osDefault
        case appDefault
    }
    
    // MARK: - Methods
    convenience init(customStyle: CustomStyle) {
        switch customStyle {
        case .osDefault:
            if #available(iOS 13.0, *) {
                self.init(style: .large)
            } else {
                self.init(style: .gray)
            }
            
        case.appDefault:
            if #available(iOS 13.0, *) {
                self.init(style: .large)
            } else {
                self.init(style: .gray)
            }

            backgroundColor = .clear
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - ActivityIndicatorInterface
    func showInRootView() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        
        guard let rootView = rootViewController?.view else {
            return
        }
        
        show(inView: rootView)
    }
    
    func show(inView view: UIView) {
        startAnimating()
        view.addSubview(self)
        autoPinEdgesToSuperviewEdges()
    }
    
    func hide() {
        removeFromSuperview()
    }
}
