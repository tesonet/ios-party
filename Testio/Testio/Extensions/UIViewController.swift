//
//  UIViewController.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func indentifier() -> String {
        return String(describing: self)
    }
}
