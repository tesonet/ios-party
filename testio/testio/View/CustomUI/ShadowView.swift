//
//  ShadowView.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/3/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class ShadowView: UIView {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func didMoveToSuperview() {
        setupView()
    }
    
    fileprivate func setupView() {
        layer.shadowOpacity = 0.25
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSize.zero
    }
}
