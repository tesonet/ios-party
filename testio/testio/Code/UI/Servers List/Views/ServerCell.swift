//
//  ServerCell.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {
    var name: String? {
        set {
            self.nameLabel.text = newValue
        }
        get {
            return self.nameLabel.text
        }
    }
    
    var distance: String? {
        set {
            self.distanceLabel.text = newValue
        }
        get {
            return self.distanceLabel.text
        }
    }
    
    private let nameLabel: UILabel
    private let distanceLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.nameLabel = UILabel()
        self.distanceLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.distanceLabel)
        
        self.makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.distanceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.distanceLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        self.nameLabel.centerYAnchor.constraint(equalTo: self.contentView.readableContentGuide.centerYAnchor).isActive = true
        self.distanceLabel.centerYAnchor.constraint(equalTo: self.contentView.readableContentGuide.centerYAnchor).isActive = true
        
        let constant: CGFloat = 6
        
        self.nameLabel.topAnchor.constraint(equalTo: self.contentView.readableContentGuide.topAnchor, constant: constant).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.readableContentGuide.bottomAnchor, constant: -constant).isActive = true
        
        self.distanceLabel.topAnchor.constraint(equalTo: self.contentView.readableContentGuide.topAnchor, constant: constant).isActive = true
        self.distanceLabel.bottomAnchor.constraint(equalTo: self.contentView.readableContentGuide.bottomAnchor, constant: -constant).isActive = true
        
        self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.readableContentGuide.leadingAnchor).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.distanceLabel.leadingAnchor).with(priority: .defaultHigh).isActive = true
        
        self.distanceLabel.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: 10).isActive = true
        self.distanceLabel.trailingAnchor.constraint(equalTo: self.contentView.readableContentGuide.trailingAnchor).isActive = true
    }
}
