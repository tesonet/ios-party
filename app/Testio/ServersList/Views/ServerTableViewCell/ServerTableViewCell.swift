//
//  ServerTableViewCell.swift
//  Testio
//
//  Created by Julius on 13/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    @IBOutlet weak var serverTitleLabel: UILabel!
    @IBOutlet weak var serverDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serverTitleLabel.textColor = UIColor.darkGrayColor
        serverDistanceLabel.textColor = UIColor.darkGrayColor
    }
    
    func setServer(_ server: ServerModel) {
        serverTitleLabel.text = server.name
        serverDistanceLabel.text = "\(server.distance) km"
    }
    
    // MARK: Public variables
    class var identifier: String {
        return "ServerTableViewCellId"
    }
    
    class var height: CGFloat {
        return 50
    }
}
