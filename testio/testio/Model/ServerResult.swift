//
//  ServerResult.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation

struct ServerResult: Codable {
    let name: String
    let distance: Int
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case distance
    }
}
