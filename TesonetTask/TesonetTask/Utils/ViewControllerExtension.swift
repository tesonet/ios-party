//
//  ViewControllerExtension.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit
import PureLayout

extension UIViewController {

    func getRootController() -> RootController {
        let rootViewController = view.topMostController()?.children.first
        guard let rootController = rootViewController as? RootController else {
            return RootViewController()
        }
        return rootController
    }

    func addChildController(_ child: UIViewController) {
        addChild(child)
        child.willMove(toParent: self)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.autoPinEdgesToSuperviewEdges()
        child.didMove(toParent: self)
    }

    func removeFromParrentController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.view.frame = .zero
        self.removeFromParent()
        self.didMove(toParent: nil)
    }
    
}
