//
//  NavigationHelpers.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func createFrom(storyboard: StoryboardNames) -> UIViewController {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: self))
    }
}


extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    class func setRootVC(_ animations: @escaping ()->()) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        UIView.transition(with: window,
                          duration: 0.5, options: .transitionCrossDissolve,
                          animations: animations,
                          completion: nil)
    }
}
