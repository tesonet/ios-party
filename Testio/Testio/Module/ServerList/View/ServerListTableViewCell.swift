//
//  ServerListTableViewCell.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {
    
    enum Constants {
        static var insets: UIEdgeInsets {
            .init(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        static var bgColor: UIColor {
            .white
        }
    }
    
    let dataView: ServerListRowDataView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let insets = Constants.insets
        
        backgroundColor = Constants.bgColor
        separatorInset = .init(top: 0, left: insets.left, bottom: 0, right: insets.right)
        selectionStyle = .none
        
        dataView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dataView)

        NSLayoutConstraint.activate([
            dataView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
            dataView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            dataView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right),
            dataView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom),
        ])
    }
    
    func apply(serverName: String?) {
        dataView.apply(serverName: serverName)
    }
    
    func apply(distanceValue: String?) {
        dataView.apply(distanceValue: distanceValue)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataView.apply(serverName: nil)
        dataView.apply(serverName: nil)
    }
}
