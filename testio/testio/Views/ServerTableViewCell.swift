//
//  ServerTableViewCell.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 07/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    static var cellID: String {
        return String(describing: self)
    }
    
    public func configureCell(for server: Server) {
        nameLabel.text = server.name
        distanceLabel.text = "\(server.distance) km"
    }
}
