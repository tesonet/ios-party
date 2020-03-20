//
//  CellItemInterface.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol CellItemInterface {
    var cell: UITableViewCell? { get set }
    var cellClass: AnyClass! { get set }
    var reuseIdentifier: String! { get set }
    func getCellHeight(_ tableView: UITableView) -> CGFloat
    var loadFromNib: Bool! { get set }
}
