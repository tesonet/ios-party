//
//  ServerCell.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/26/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {

    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
