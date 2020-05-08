//
//  ServerCell.swift
//  party
//
//  Created by Paulius on 08/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import UIKit

final class ServerCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    func setup(with server: Server) {
        titleLabel.text = server.name
        distanceLabel.text = "\(server.distance) km"
    }
}
