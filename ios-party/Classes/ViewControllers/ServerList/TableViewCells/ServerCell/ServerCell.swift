//
//  ServerCell.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

class ServerCell: UITableViewCell {

    // MARK: - Declarations
    var server: ServerEntity?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - Methods
    func populate(withServer server: ServerEntity) {
        reset()
        
        self.server = server
        nameLabel.text = server.name
        distanceLabel.text = String(server.distance)
    }
    
    // MARK: - Helpers
    func reset() {
        server = nil
        nameLabel.text = nil
        distanceLabel.text = nil
    }
}
