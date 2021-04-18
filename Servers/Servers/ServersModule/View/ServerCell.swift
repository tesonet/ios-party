//
//  ServerCell.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

class ServerCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!

    func update(with server: ServerModel) {
        nameLabel.text = server.name
        distanceLabel.text = format(distance: server.distance)
        updateUI()
    }
    
    private func updateUI() {
        nameLabel.textColor = ServerConstants.cell.textColor
        distanceLabel.textColor = ServerConstants.cell.textColor
    }
    
    private func format(distance: Int) -> String {
        return String(distance) + " km"
    }
}
