//
//  ServersListSectionHeaderView.swift
//  Testio
//
//  Created by Julius on 13/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

class ServersListSectionHeaderView: ViewFromXib {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func setup() {
        super.setup()
        serverLabel.textColor = UIColor.grayColor
        distanceLabel.textColor = UIColor.grayColor
        setupShadowView()
    }
    
    func setupShadowView() {
        shadowView.layer.shadowRadius = 20
        shadowView.layer.shadowColor = UIColor.rgb(r: 7, g: 38, b: 56).cgColor
        shadowView.layer.shadowOpacity = 0.3
    }
    
    class var height: CGFloat {
        return 80
    }
}
