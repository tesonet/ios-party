//
//  ServerListTableViewCell.swift
//  testio
//
//  Created by Justinas Baronas on 17/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    // MARK: - Cell refresh
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        distanceLabel.text = nil
    }
    
    
    // MARK: - Setup
    public func setupCell(with server: Server) {
        nameLabel.text = server.name
        distanceLabel.text = "\(server.distance) km"
    }
    
}
