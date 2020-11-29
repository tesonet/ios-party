//
//  ServerListTableViewCell.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {

    // MARK: - Declarations
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private(set) var server: ServerListEntity?
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populate(with server: ServerListEntity) {
        reset()
        
        self.server = server
        
        locationLabel.text = server.name
        distanceLabel.text = "\(server.distance) km"
    }
    
    func reset() {
        locationLabel.text = nil
        distanceLabel.text = nil
    }
}
