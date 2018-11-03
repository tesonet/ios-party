//
//  ServerCell.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/3/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {
    
    private var serverNameLabel = FancyLabel()
    private var serverDistanceLabel = FancyLabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(withServer server: Server) {
        serverNameLabel.text = server.name
        serverDistanceLabel.text = "\(server.distance) km"
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(serverNameLabel)
        contentView.addSubview(serverDistanceLabel)
        serverDistanceLabel.textAlignment = .left
        
    }
    
    private func setupConstraints() {
        serverNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        serverNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        serverDistanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14.0).isActive = true
        serverDistanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        serverDistanceLabel.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
    
}
