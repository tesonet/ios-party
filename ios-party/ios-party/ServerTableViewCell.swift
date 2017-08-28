//
//  ServerTableViewCell.swift
//  ios-party
//
//  Created by Adomas on 28/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setupUI(server: Server) {
        self.locationLabel.text = server.name
        self.distanceLabel.text = "\(server.distance) km"
    }
}
