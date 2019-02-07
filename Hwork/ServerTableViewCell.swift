//
//  ServerTableViewCell.swift
//  Hwork
//
//  Created by Robertas Pauzas on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var distanceWidth: NSLayoutConstraint!
    
    
    func configCell(name:String, distance: Int16) {
        self.name.text = name
        self.distance.text = String(distance) + " " + "km"
        let font = UIFont(name: "Roboto-Light", size: 11.0 * Const.sizeMultiplyer)
        self.name.font = font
        self.distance.font = font
        distanceWidth.constant = 58 * Const.sizeMultiplyer
    }
    
}
