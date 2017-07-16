//
//  ServerCell.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import UIKit

class ServerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    class func height() -> CGFloat {
        return 39
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = UIFont.applicationFont(.light, size: 11)
        nameLabel.textColor = UIColor.appListContent
        
        distanceLabel.font = UIFont.applicationFont(.light, size: 11)
        distanceLabel.textColor = UIColor.appListContent
    }
    
    func setup(server: ServerModel) {
        nameLabel.text = server.name
        distanceLabel.text = String(format: "ServerDistanceFormat".localized, server.distance)
    }
}
