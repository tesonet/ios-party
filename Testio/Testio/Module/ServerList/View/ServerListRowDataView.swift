//
//  ServerListRowDataView.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class ServerListRowDataView: UIStackView {
    
    enum Constants {
        static var distanceLabelWidth: CGFloat {
            78
        }
        
        static var color: UIColor  {
            UIColor(named: "mainGray")!
        }
        
        static var font: UIFont {
            UIFont.systemFont(ofSize: 13)
        }
    }
    
    private let serverLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.font
        label.textColor = Constants.color
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.font
        label.textColor = Constants.color
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .horizontal
        distribution = .fill
        
        addArrangedSubview(serverLabel)
        addArrangedSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            distanceLabel.widthAnchor.constraint(equalToConstant: Constants.distanceLabelWidth)
        ])
    }
    
    public func apply(serverName: String?) {
        serverLabel.text = serverName
    }
    
    public func apply(distanceValue: String?) {
        distanceLabel.text = distanceValue
    }
}

