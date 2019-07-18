//
//  UIViewController+rootAppViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Iterates through view controllers in navigation stack to find RootAppViewController.
    ///
    /// - Returns: A root app view controller or nil if it was not found.
    func rootAppViewController() -> RootAppViewController? {
        let parentViewControllers = sequence(first: self, next: { $0.presentingViewController ?? $0.parent })
        for viewController in parentViewControllers {
            if let rootAppViewController = viewController as? RootAppViewController {
                return rootAppViewController
            }
        }
        return nil
    }
}

