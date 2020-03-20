//
//  ServelCellItem.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-20.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class ServelCellItem: CellItem {
    
    let server: ServersResponse
    
    init(server: ServersResponse) {
        self.server = server
        super.init()
    }
    
    override func loadCell(_ cell: UITableViewCell) {
        self.cell = cell
        guard let cell = cell as? ServelCell else { return }
        cell.distanceLabel.text = "\(server.distance) km"
        cell.nameLabel.text = server.name
    }
    
    override func getCellClass() -> AnyClass {
        return ServelCell.self
    }
    
    override func createIdentifier() -> String {
        return String(describing: ServelCell.self)
    }
}
