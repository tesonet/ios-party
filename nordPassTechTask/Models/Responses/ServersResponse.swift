//
//  ServersResponse.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation

struct ServersResponse: Decodable {
    let servers: [ServerDTO]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        servers = try container.decode([ServerDTO].self)
    }
}
