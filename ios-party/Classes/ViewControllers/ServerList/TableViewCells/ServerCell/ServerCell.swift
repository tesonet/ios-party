//
//  ServerCell.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import UIKit

class ServerCell: UITableViewCell {

    // MARK: - Declarations
    var server: ServerEntity?
    
    // MARK: - Methods
    func populate(withServer server: ServerEntity) {
        reset()
    }
    
    // MARK: - Helpers
    func reset() {
        server = nil
    }
}
