//
//  CellItem.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class CellItem: NSObject, CellItemInterface {
    
    var cellClass: AnyClass!
    var reuseIdentifier: String!
    var xibName : String!
    
    weak var cell: UITableViewCell?
    var loadFromNib: Bool!
    weak var tableManager: TableViewManager?
    
    override init() {
        super.init()
        reuseIdentifier = createIdentifier()
        cellClass = getCellClass()
        xibName = createIdentifier()
        loadFromNib = getLoadFromNib()
    }
    
    internal func loadCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "ovveride me"
    }
    
    internal func getCellClass() -> AnyClass {
        return UITableViewCell.self
    }
    
    internal func createIdentifier() -> String {
        return "DefaultCell"
    }
    
    func getCellHeight(_ tableView: UITableView) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func getLoadFromNib() -> Bool {
        return true
    }
    
    func willDisplayCell(cell: UITableViewCell) {}
    
}

