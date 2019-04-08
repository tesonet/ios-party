// Created by Paulius Cesekas on 01/04/2019.

import Foundation

public struct Server {
    public let name: String
    public let distance: Int
    
    public init(name: String,
                distance: Int) {
        self.name = name
        self.distance = distance
    }
}
