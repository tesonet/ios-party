//
//  UIViewControllerExtensions.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addContentController(_ contentController: UIViewController) {
        self.addContentController(contentController, to: self.view)
    }
    
    func addContentController(_ contentController: UIViewController, to childView: UIView) {
        self.addChildViewController(contentController)
        childView.addSubview(contentController.view)
        contentController.didMove(toParentViewController: self)
    }
    
    func removeContentController(_ contentController: UIViewController) {
        contentController.willMove(toParentViewController: nil)
        contentController.view.removeFromSuperview()
        contentController.removeFromParentViewController()
    }
}
