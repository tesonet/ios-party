//
//  ServerCell.swift
//  PartySwift
//
//  Created by Arturas Kuciauskas on 24.11.2019.
//  Copyright © 2019 Party. All rights reserved.
//

import UIKit

class ServerCell: UICollectionViewCell
{
    
    let nameLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.text = "SERVER"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0)

       return label
    }()

    let distanceLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.text = "DISTANCE"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        label.textAlignment = .left
    

       return label
    }()
    
    let separatorLine: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        return view
    }()
    
    var serverObject: Server?
    {
        didSet
        {
            updateView()
        }
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.distanceLabel)
        self.contentView.addSubview(self.separatorLine)
        
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config()
    {
       NSLayoutConstraint.activate([
        
        self.nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0.0),
        self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0),
        self.nameLabel.heightAnchor.constraint(equalToConstant: 15.0),
        
        self.distanceLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0.0),
        self.distanceLabel.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -90.0),
        self.distanceLabel.heightAnchor.constraint(equalToConstant: 15.0),
        
        self.separatorLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0.0),
        self.separatorLine.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0),
        self.separatorLine.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15.0),
        self.separatorLine.heightAnchor.constraint(equalToConstant: 1.0),

       ])
    }
    
    func updateView()
    {
        if let serverName = serverObject?.name
        {
            self.nameLabel.text = serverName
        }
        
        if let distance = serverObject?.distance
        {
            self.distanceLabel.text = "\(distance) km"
        }
        
    }
    
}
