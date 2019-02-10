//
//  ServerViewCell.swift
//  Testio
//
//  Created by lbartkus on 10/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import UIKit

class ServerViewCell: UITableViewCell {
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var serverDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(with model: Server) {
        serverNameLabel.text = model.name
        serverDistanceLabel.text = model.distance.asKm()
    }
}
