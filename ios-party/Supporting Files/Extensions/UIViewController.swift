//
//  UIViewController.swift
//  ios-party
//
//  Created by Артём Зиньков on 10/1/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

extension UIViewController {
    public static func instantiate() -> Self? {
        if let storyboardName = NSStringFromClass(self).components(separatedBy: ".").last,
            let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardName) as? Self {
            
            return controller
        }
        
        return nil
    }
}
