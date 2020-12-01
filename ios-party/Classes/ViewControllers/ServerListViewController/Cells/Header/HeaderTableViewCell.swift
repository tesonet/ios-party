//
//  HeaderTableViewCell.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    // MARK: - Declarations
    @IBOutlet private weak var serverLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    // MARK: - Methods
    func populate(serverTitle: String, distanceTitle: String) {
        reset()
        
        self.serverLabel.text = serverTitle
        self.distanceLabel.text = distanceTitle
    }
    
    // MARK: - Helpers
    private func reset() {
        serverLabel.text = nil
        distanceLabel.text = nil
    }
    
}
