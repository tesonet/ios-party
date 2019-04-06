//
//  ServerTableViewCell.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit

final class ServerTableViewCell: UITableViewCell {

    @IBOutlet private var serverNameLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    
    func setup(with server: Server) {
        serverNameLabel.text = server.name
        distanceLabel.text = "\(server.distance) km"
    }
    
}
