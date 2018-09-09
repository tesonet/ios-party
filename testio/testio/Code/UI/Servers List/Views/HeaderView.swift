//
//  HeaderViewCell.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit

extension ServersListViewController {
    class HeaderView: UIView {
        private let serverLabel: UILabel
        private let distanceLabel: UILabel
        
        override init(frame: CGRect) {
            self.serverLabel = UILabel()
            self.serverLabel.textColor = .lightGray
            self.serverLabel.text = NSLocalizedString("Server", comment: "")
            
            self.distanceLabel = UILabel()
            self.distanceLabel.textColor = .lightGray
            self.distanceLabel.text = NSLocalizedString("Server", comment: "")
            self.distanceLabel.textAlignment = .right
            
            super.init(frame: frame)
            
            self.backgroundColor = .white
            
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 0.5
            
            self.addSubview(self.serverLabel)
            self.addSubview(self.distanceLabel)
            
            self.makeConstraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func makeConstraints() {
            self.serverLabel.translatesAutoresizingMaskIntoConstraints = false
            self.distanceLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.serverLabel.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor).isActive = true
            self.serverLabel.topAnchor.constraint(equalTo: self.readableContentGuide.topAnchor, constant: 14).isActive = true
            self.serverLabel.bottomAnchor.constraint(equalTo: self.readableContentGuide.bottomAnchor, constant: -14).isActive = true
            
            self.distanceLabel.trailingAnchor.constraint(equalTo: self.readableContentGuide.trailingAnchor).isActive = true
            self.distanceLabel.centerYAnchor.constraint(equalTo: self.serverLabel.centerYAnchor).isActive = true
        }
    }
}
