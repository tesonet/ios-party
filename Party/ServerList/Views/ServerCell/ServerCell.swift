//
//  ServerCell.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {

    // MARK: - UI Components
    
    @IBOutlet weak private var serverLabel: UILabel!
    
    @IBOutlet weak private var distanceLabel: UILabel!
    
    // MARK: - Public Methods
    
    func configure(with viewModel: ServerCellViewModel) {
        serverLabel.text = viewModel.serverName
        distanceLabel.text = viewModel.distance
    }
}
