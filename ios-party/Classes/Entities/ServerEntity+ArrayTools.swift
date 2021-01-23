//
//  ServerEntity+ArrayTools.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import Foundation

extension Array where Element: ServerEntity {
    
    func sorted(by sortType: ServerSortType) -> [ServerEntity] {
        guard !self.isEmpty else {
            return self
        }
        
        switch sortType {
        case .alphanumerical:
            return self.sorted(by: { $0.name < $1.name })
            
        case .distance:
            return self.sorted(by: { $0.distance < $1.distance })
        }
    }
}
