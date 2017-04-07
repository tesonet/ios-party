//
//  LoginButton.swift
//  GreatiOSApp
//
//  Created by Domas on 4/6/17.
//  Copyright © 2017 Sonic Team. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        
    }
    
    init(){
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp(){
        self.layer.cornerRadius = 3
    }
}
