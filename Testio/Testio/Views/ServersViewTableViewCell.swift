//
//  ServersViewTableViewCell.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class ServersViewTableViewCell: UITableViewCell
{
    private var distanceLabel: UILabel!
    private var nameLabel:UILabel!
    
    var server: Server?
    {
        didSet
        {
            guard let distance = server?.distance else
            {
                return
            }
            distanceLabel = createLabelWith(text: "\(String(describing: distance)) km")
            
            nameLabel = createLabelWith(text: server?.name)
            addSubview(nameLabel)
            addSubview(distanceLabel)
            distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
            distanceLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 60).isActive = true
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        distanceLabel.text = nil
    }
    
    func createLabelWith(text: String?) -> UILabel
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        label.textAlignment = .left
        return label
    }
}
