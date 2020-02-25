//
//  ServerCell.swift
//  Tesonet
//
//  Created by Александр on 2/25/20.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {

    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    var model: ServerModel? {
        didSet {
            onModelUpdate()
        }
    }

    func onModelUpdate() {
        guard let model = model else {
            serverNameLabel.text = nil
            distanceLabel.text = nil
            return
        }
        serverNameLabel.text = model.serverName
        distanceLabel.text = "\(model.distanceToServer)km"
    }

    override func prepareForReuse() {
        model = nil
    }
}
