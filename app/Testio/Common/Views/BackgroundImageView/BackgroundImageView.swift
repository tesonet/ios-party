//
//  BackgroundImageView.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

@IBDesignable
class BackgroundImageView: ViewFromXib {
    @IBOutlet weak var imageView: UIImageView!
    
    override func setup() {
        super.setup()
        addOpacityGradient()
    }
    
    func addOpacityGradient() {
        let maskLayer = CAGradientLayer()
        maskLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        maskLayer.startPoint = CGPoint(x: 0, y: 0)
        maskLayer.endPoint = CGPoint(x: 0, y: 1)
        maskLayer.frame = imageView.frame
        imageView.layer.mask = maskLayer
    }
}
