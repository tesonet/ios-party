//
//  TableView+Helpers.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

extension UITableView {
    
    // MARK: - Methods
    public func registerCellNib<T: UITableViewCell>(withType type: T.Type) {
    
        let identifier = stringFromClass(type)
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCellWithClass(_ aClass: AnyClass) -> UITableViewCell? {
        
        let identifier = stringFromClass(aClass)
        let cell: UITableViewCell? = dequeueReusableCell(withIdentifier: identifier)
        return cell
    }
    
    func hideEmptyTableViewCells() {
        self.tableFooterView = UIView()
    }
    
    // MARK: - Helpers
    private func stringFromClass(_ aClass: AnyClass) -> String {
        guard let className: String = NSStringFromClass(aClass).components(separatedBy: ".").last else {
            print("ERROR! could not get class name from class: \(aClass)")
            return ""
        }
        
        return className
    }
}
