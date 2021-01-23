//
//  UITableView+Tools.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

extension UITableView {
    
    // MARK: - Methods
    // MARK: - Cells
    public func registerCellNib<T: UITableViewCell>(withType type: T.Type) {
        
        let identifier: String = className(fromClass: type)
        
        guard Bundle.main.path(forResource: identifier, ofType: "nib") != nil else {
            log("ERROR! Could not find NIB - \(identifier) in main bundle")
            return
        }
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        
        let identifier: String = className(fromClass: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            log("ERROR! Could not dequeue cell with identifier \(identifier) for indexPath \(indexPath) ")
            return nil
        }
        
        return cell
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type = T.self) -> T? {
        // Concrete class is indicated by parameter:
        // let cell: AaaTableViewCellProtocol = tableView.dequeueReusableCell(withType: AaaTableViewCell.self)
        // If parameter is not used, class is indicated by type of variable the return value is assigned to:
        // let cell: AaaTableViewCell = tableView.dequeueReusableCell()
        
        let identifier: String = className(fromClass: type)
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            log("ERROR! Could not dequeue cell with identifier \(identifier)")
            return nil
        }
        
        return cell
    }
    
    // MARK: - HeaderFooterViews
    public func registerHeaderFooterViewNib<T: UITableViewHeaderFooterView>(withType type: T.Type) {
        let identifier: String = className(fromClass: type)
        
        guard Bundle.main.path(forResource: identifier, ofType: "nib") != nil else {
            log("ERROR! Could not find NIB - \(identifier) in main bundle")
            return
        }
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withType type: T.Type = T.self) -> T? {
        let identifier: String = className(fromClass: type)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            log("ERROR! Could not dequeue HeaderFooterView with identifier \(identifier)")
            return nil
        }
        
        return cell
    }
}
