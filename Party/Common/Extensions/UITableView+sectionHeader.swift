//
//  UITableView+sectionHeader.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerHeaderFoorterNib<T>(withType type: T.Type) where T: UITableViewHeaderFooterView {
        let identifier: String = String.classNameAsString(type)
        let nib: UINib? = UINib(nibName: identifier, bundle: Bundle.main)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueReusableHeaderFooter<T>() -> T where T: UITableViewHeaderFooterView {
        let identifier: String = String.classNameAsString(T.self)
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }
}
