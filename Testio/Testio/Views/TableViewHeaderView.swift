//
//  TableViewHeaderView.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class gradientView : UIView
{
    var isGoingUp:Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradient = CAGradientLayer()

        gradient.frame = rect
        let darkerColor = UIColor.init(red: 226/255, green: 229/255, blue: 232/255, alpha: 1.0).cgColor
            
        gradient.colors = isGoingUp ? [UIColor.white.cgColor, darkerColor] : [darkerColor, UIColor.white.cgColor]

        layer.insertSublayer(gradient, at: 0)
    }
}

class TableViewHeaderView: UIView
{
    private let bottomGradient : gradientView = {
        let bottomGradient = gradientView()
        bottomGradient.translatesAutoresizingMaskIntoConstraints = false
        return bottomGradient
    }()
    
    private let upperGradient : gradientView = {
        let upperGradient = gradientView()
        upperGradient.isGoingUp = true
        upperGradient.translatesAutoresizingMaskIntoConstraints = false
        return upperGradient
    }()
    
    func setup()
    {
        addSubview(bottomGradient)
        bottomGradient.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        bottomGradient.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        bottomGradient.topAnchor.constraint(equalTo: centerYAnchor, constant: 25.0).isActive = true
        bottomGradient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        
        addSubview(upperGradient)
        upperGradient.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        upperGradient.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        upperGradient.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        upperGradient.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -25.0).isActive = true
        
        let serversLabel = UILabel()
        serversLabel.translatesAutoresizingMaskIntoConstraints = false
        serversLabel.text = "SERVER"
        serversLabel.font = UIFont.systemFont(ofSize: 12.0)
        serversLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        serversLabel.textAlignment = .left
        addSubview(serversLabel)
        serversLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0).isActive = true
        serversLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        let distanceLabel = UILabel()
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.text = "DISTANCE"
        distanceLabel.font = UIFont.systemFont(ofSize: 12.0)
        distanceLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        distanceLabel.textAlignment = .right
        addSubview(distanceLabel)
        distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.0).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
    }
}
