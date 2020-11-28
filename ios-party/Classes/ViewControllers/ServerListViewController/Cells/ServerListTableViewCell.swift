//
//  ServerListTableViewCell.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populate() {
        reset()
    }
    
    func reset() {
        locationLabel.text = nil
        distanceLabel.text = nil
    }
    
}
