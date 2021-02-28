//
//  ServerListHeaderView.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class ServerListHeaderView: UIView {
        
    enum Constants {
        static var insets: UIEdgeInsets {
            .init(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        static var shadowColor: UIColor {
            .black
        }
        
        static var shadowOpacity: Float {
            0.2
        }
        
        static var shadowRadius: CGFloat {
            14
        }
        
        static var shadowOffset: CGSize {
            .zero
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .white
        
        let dataView = ServerListRowDataView()
        dataView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dataView)
        
        dataView.apply(serverName: "Server".uppercased())
        dataView.apply(distanceValue: "Distance".uppercased())
        
        let insets = Constants.insets
        NSLayoutConstraint.activate([
            dataView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
            dataView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            dataView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
            dataView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
        ])
        
        layer.shadowColor = Constants.shadowColor.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
    }
}
