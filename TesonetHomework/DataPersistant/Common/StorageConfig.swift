// Created by Paulius Cesekas on 01/04/2019.

import Foundation

public struct StorageConfig {
    let path: String?
    
    public init(path: String? = nil) {
        self.path = path
    }
}
