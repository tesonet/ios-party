//
//  ServerTableViewCell.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

final class ServerTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = PartyColor.darkGray
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = PartyColor.darkGray
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = PartyColor.lightGray
        setupLayout()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        distanceLabel.text = nil
    }
    
    private func setupLayout() {
        [nameLabel, distanceLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: distanceLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            distanceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
    
}
