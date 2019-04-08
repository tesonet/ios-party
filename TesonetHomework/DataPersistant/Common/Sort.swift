// Created by Paulius Cesekas on 07/04/2019.

import Foundation

public struct Sort {
    var key: String
    var ascending: Bool
    
    public init(key: String,
                ascending: Bool = true) {
        self.key = key
        self.ascending = ascending
    }
}
