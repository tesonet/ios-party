//
//  ProducersTableCell.swift
//  FarmDrop
//
//  Created by Robertas Baronas on 04/02/2017.
//  Copyright © 2017 Robertas Baronas. All rights reserved.
//

import UIKit

class ServersTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with item: Server) {
        nameLabel.text = item.name
        distanceLabel.text = String(item.distance)
    }
}
