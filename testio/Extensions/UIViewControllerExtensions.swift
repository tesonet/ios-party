//
//  UIViewControllerExtensions.swift
//  testio
//
//  Created by Justinas Baronas on 25/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit

extension UIViewController {
    var appDelegate: UIApplicationDelegate {
        guard let appDelegate = UIApplication.shared.delegate else {
            fatalError("Could not determine appDelegate.")
        }
        return appDelegate
    }

}
