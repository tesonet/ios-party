//
//  ServelCell.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-20.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class ServelCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}
