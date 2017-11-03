//
//  Server.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 16/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import Foundation

class Server {
    var name : String = "";
    var distance : Int = 0;
    
    init(name: String, distance: Int){
        self.name = name
        self.distance = distance
    }
}
