//
//  ServersTableViewCell.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell, ReusableView {

    private let leftLabel: UILabel = ServerTableViewCell.createHeaderLabel()
    private let rightLabel: UILabel = ServerTableViewCell.createHeaderLabel()
    
    private static func createHeaderLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        return label
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        addLabelConstraints()
    }
    
}


extension ServerTableViewCell {

    func update(withLeftLabelText leftText: String, rightLabelText rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
    
    private func addLabelConstraints() {
        
        let leftLabelConstraints = [
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(leadingAnchor, multiplier: 2)
        ]
        
        NSLayoutConstraint.activate(leftLabelConstraints)
        
        let rightLabelConstraints = [
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraintEqualToSystemSpacingAfter(rightLabel.trailingAnchor, multiplier: 2)
        ]
        
        NSLayoutConstraint.activate(rightLabelConstraints)
    }
    
}
