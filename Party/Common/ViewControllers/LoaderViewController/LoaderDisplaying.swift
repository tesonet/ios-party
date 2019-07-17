//
//  LoaderDisplaying.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

protocol LoaderDisplaying {
    
    func showLoader(on viewController: UIViewController)
    
    func dismissLoader(from viewController: UIViewController, completionHandler: (() -> Void)?)
    
}

extension LoaderDisplaying {
    
    func showLoader(on viewController: UIViewController) {
        if viewController.presentedViewController is LoaderViewController {
            return
        }
        
        let loaderViewController = LoaderViewController.make()
        viewController.present(loaderViewController, animated: true, completion: nil)
    }
    
    func dismissLoader(from viewController: UIViewController, completionHandler: (() -> Void)? = nil) {
        if let loaderViewController = viewController.presentedViewController as? LoaderViewController {
            loaderViewController.dismiss(animated: true, completion: {
                completionHandler?()
            })
        } else {
            completionHandler?()
        }
    }
}

extension LoaderDisplaying where Self: UIViewController {
    
    func showLoader() {
        showLoader(on: self)
    }
    
    func dismissLoader(completionHanler: (() -> Void)?) {
        dismissLoader(from: self, completionHandler: completionHanler)
    }
}
