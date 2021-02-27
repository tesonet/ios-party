//
//  Server.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

struct Server {
    let name: String?
    let distance: Double?
}

extension Server: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case distance = "distance"
    }
}
