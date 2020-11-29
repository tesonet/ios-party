//
//  HeaderTableViewCell.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var serverLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    func populate(serverTitle: String, distanceTitle: String) {
        reset()
        
        self.serverLabel.text = serverTitle
        self.distanceLabel.text = distanceTitle
    }
    
    func reset() {
        serverLabel.text = nil
        distanceLabel.text = nil
    }
    
}
