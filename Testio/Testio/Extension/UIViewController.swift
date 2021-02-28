//
//  UIViewController.swift
//  Testio
//
//  Created by Claus on 28.02.21.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func transition(from: UIViewController?, to: UIViewController, completion: ((Bool) -> ())? = nil) {
        guard let from = from else {
            add(to)
            completion?(true)
            return
        }
        
        addChild(to)
        from.willMove(toParent: nil)
        transition(from: from, to: to, duration: 0.3, options: .transitionCrossDissolve, animations: {
            from.removeFromParent()
            to.didMove(toParent: self)
            self.setNeedsStatusBarAppearanceUpdate()
        }) { finished in
            completion?(finished)
        }
    }
}
