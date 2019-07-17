//
//  ServerCellViewModel.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

struct ServerCellViewModel {

    let serverName: String
    
    let distance: String
}

// MARK: -

extension ServerCellViewModel: CellRepresentable {
    
    // MARK: - CellRepresentable
    
    func cellInstance(in tableView: UITableView) -> UITableViewCell {
        let cell: ServerCell = tableView.dequeueReusableCell()
        cell.configure(with: self)
        return cell
    }
    
    var cellHeight: CGFloat {
        return 44
    }
}
