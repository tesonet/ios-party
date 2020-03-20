//
//  PaddingCellItem.swift
//  Momo
//
//  Created by Jaroslav Chaninovicz on 2020-01-22.
//  Copyright © 2020 lt.ito. All rights reserved.
//

import UIKit

class PaddingCellItem: CellItem {
    
    var height: CGFloat?
    var color: UIColor?
    
    init(height: CGFloat? = nil) {
        self.height = height
        super.init()
    }
    
    init(height: CGFloat? = nil, color: UIColor? = nil) {
        self.height = height
        self.color = color
        super.init()
    }
    
    override func loadCell(_ cell: UITableViewCell) {
        self.cell = cell
        guard let cell = cell as? PaddingCell else { return }
        guard let color = color else {
            cell.backgroundColor = .clear
            return
        }
        cell.backgroundColor = color
    }
    
    override func getCellClass() -> AnyClass {
        return PaddingCell.self
    }
    
    override func createIdentifier() -> String {
        return String(describing: PaddingCell.self)
    }
    
    override func getCellHeight(_ tableView: UITableView) -> CGFloat {
        if let height = height {
            return height
        }
        
        return 20
    }
    
    override func getLoadFromNib() -> Bool {
        return true
    }
    
}
