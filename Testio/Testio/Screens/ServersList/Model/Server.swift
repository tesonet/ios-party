//
//  UserCredentials.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import Foundation

struct Server: Decodable {
    let name: String
    let distance: Int
}

extension Server {
    var formattedDistance: String {
        return String.localizedStringWithFormat(ServersListLocalization.server.formattedDistance, distance)
    }
}
