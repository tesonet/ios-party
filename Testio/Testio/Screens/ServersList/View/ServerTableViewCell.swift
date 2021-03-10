//
//  CarInfoTableViewCell.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import UIKit

final class ServerTableViewCell: UITableViewCell, ReusableCellProtocol {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
        
    func update(with server: Server) {
        nameLabel.text = server.name
        distanceLabel.text = server.formattedDistance
    }
}
