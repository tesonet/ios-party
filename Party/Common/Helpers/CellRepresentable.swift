//
//  CellRepresentable.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    
    var cellHeight: CGFloat { get }
    
    func cellInstance(in tableView: UITableView) -> UITableViewCell
}

extension CellRepresentable {
    
    var cellHeight: CGFloat {
        return UITableView.automaticDimension
    }
}
