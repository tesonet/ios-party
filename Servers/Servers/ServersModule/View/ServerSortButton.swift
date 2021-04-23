//
//  ServerSortButton.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

class ServerSortButton: BaseButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(ServerConstants.button.title, for: .normal)
        backgroundColor = ServerConstants.button.backgroundColor
        tintColor = ServerConstants.button.tintColor
        
        setImage(ServerConstants.button.image, for: .normal)
        
        imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}

