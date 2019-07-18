//
//  UIStoryboard+initialViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    /// returns initial view controller in given storyboard.
    func initialViewController() -> UIViewController {
        guard let viewController = instantiateInitialViewController() else {
            fatalError("WARNING: failed to instantiate initialViewController for storyboard")
        }
        return viewController
    }
}
