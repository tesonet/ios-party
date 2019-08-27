//
//  TableViewExtensions.swift
//  testio
//
//  Created by Justinas Baronas on 19/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit

/// Is used to get reuseIdentifier from view ex: cell
protocol ReusableView {
    
    ///Cell reuseIdentifier
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }



extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        return cell
    }
    
}
