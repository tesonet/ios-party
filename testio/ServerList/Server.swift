//
//  Servers.swift
//  testio
//
//  Created by Justinas Baronas on 18/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import Foundation


struct Server: Codable, Equatable {
    
    let name: String
    let distance: Int
    
    
    enum CodingKeys: CodingKey {
        case name
        case distance
    }
}





