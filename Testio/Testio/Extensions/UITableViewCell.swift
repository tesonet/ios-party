//
//  UITableViewCell.swift
//  Testio
//
//  Created by lbartkus on 10/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        return String(describing: self)
    }
    
    static func reuseNib() -> UINib {
        return UINib(nibName: identifier(), bundle: nil)
    }
    
    static func register(tableView: UITableView) {
        tableView.register(reuseNib(), forCellReuseIdentifier: identifier())
    }
}
