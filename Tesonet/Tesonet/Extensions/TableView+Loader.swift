//
//  TableView+Loader.swift
//  Tesonet
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: className(classType: cellClass))
    }

    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: className(classType: cellClass)) as? T else {
            fatalError("Cannot instantiate cell \(className(classType: cellClass))")
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: className(classType: cellClass), for: indexPath) as? T else {
            fatalError("Cannot instantiate cell \(className(classType: cellClass))")
        }
        return cell
    }
}
