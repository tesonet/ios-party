//
//  Button.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.rgb(r: 159, g: 213, b: 51)
        layer.cornerRadius = 5
    }
}
