//
//  UIView+Extensions.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/27/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = TesioHelper.Constant.Color.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    }
    
}
