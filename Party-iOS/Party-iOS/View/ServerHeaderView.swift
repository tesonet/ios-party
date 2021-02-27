//
//  ServerHeaderView.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

final class ServerHeaderView: UIView {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = PartyColor.gray
        label.font = .systemFont(ofSize: 9)
        label.text = "SERVER"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = PartyColor.gray
        label.font = .systemFont(ofSize: 9)
        label.text = "DISTANCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [nameLabel, distanceLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: distanceLabel.leadingAnchor),
            
            distanceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -10),
            distanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
