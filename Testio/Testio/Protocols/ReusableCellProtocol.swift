//
//  CellId.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

protocol ReusableCellProtocol: UITableViewCell {
  static var cellId: String { get }
  static func register(in tableView: UITableView)
  static func dequeueReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Self
}

extension ReusableCellProtocol {
  static var cellId: String {
    return String(describing: self)
  }
  
  static func register(in tableView: UITableView) {
    tableView.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: self.cellId)
  }
  
  static func dequeueReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Self {
    return tableView.dequeueReusableCell(withIdentifier: Self.cellId, for: indexPath) as! Self
  }
}
