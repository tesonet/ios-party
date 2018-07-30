//
//  ServersTableViewHeader.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class ServersTableViewHeader: UIView {

    private static let defaultHeight: CGFloat = 50
    
    private let leftLabel: UILabel = ServersTableViewHeader.createHeaderLabel()
    private let rightLabel: UILabel = ServersTableViewHeader.createHeaderLabel()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func createHeaderLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        label.textColor = .lightGray
        return label
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.masksToBounds = false
        addSubview(leftLabel)
        addSubview(rightLabel)
    }
    
    func addConstraints() {
        guard let superview = self.superview else {
            fatalError("view should have a superview")
        }
        
        let constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            heightAnchor.constraint(equalToConstant: ServersTableViewHeader.defaultHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
        addLabelConstraints()
    }
    
}

extension ServersTableViewHeader {
    
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
