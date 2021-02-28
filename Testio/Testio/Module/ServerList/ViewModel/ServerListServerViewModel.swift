//
//  ServerListServerViewModel.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import Foundation

struct ServerListServerViewModel {
    let name: String
    let distance: String
}

extension ServerListServerViewModel {
    func populate(cell: ServerListTableViewCell) {
        cell.apply(serverName: name)
        cell.apply(distanceValue: distance)
    }
}
