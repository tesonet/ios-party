//
//  FancyLabel.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/3/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class FancyLabel: UILabel {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupView()
    }
    
    fileprivate func setupView() {
        
        self.numberOfLines = 0
        self.adjustsFontForContentSizeCategory = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.font = UIFont(name: "Arial", size: 14.0)
        self.textColor = #colorLiteral(red: 0.4288323522, green: 0.4288323522, blue: 0.4288323522, alpha: 1)
        
        
    }
}
