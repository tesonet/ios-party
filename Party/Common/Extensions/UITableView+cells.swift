//
//  UITableView+cells.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Registers cell nib by its class name.
    ///
    /// - Parameter type: A cell class type.
    func registerCellNib<T>(withType type: T.Type) where T: UITableViewCell {
        let identifier: String = String.classNameAsString(type)
        let nib: UINib? = UINib(nibName: identifier, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// Degueues reusable cell.
    ///
    /// - Parameter indexPath: A cells indexpath in tableview.
    /// - Returns: A reused cell instance.
    func dequeueReusableCell<T>(indexPath: IndexPath? = nil) -> T where T: UITableViewCell {
        let identifier: String = String.classNameAsString(T.self)
        if let indexPath = indexPath {
            return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
        } else {
            return dequeueReusableCell(withIdentifier: identifier) as! T
        }
    }
}
