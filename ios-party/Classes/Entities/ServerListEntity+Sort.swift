//
//  ServerListEntity+Sort.swift
//  ios-party
//
//  Created by Lukas on 11/30/20.
//

import Foundation

enum serverListSortType {
    case notSorted
    
    case byAlphanumeric
    case byDistance
}

extension ServerListEntity {
    
    class func serverList(_ serverList: [ServerListEntity], sortedBy: serverListSortType) -> [ServerListEntity] {
        guard serverList.isEmpty == false else { return [] }
        
        switch sortedBy {
        case .notSorted:
            return serverList
        case .byAlphanumeric:
            return sortServerListByAlphanumeric(serverList)
        case .byDistance:
            return sortServerListByDistance(serverList)
        }
    }
    
    class private func sortServerListByAlphanumeric(_ serverList: [ServerListEntity]) -> [ServerListEntity] {
        
        return serverList.sorted { (firstServer, secondServer) -> Bool in
            return firstServer.name.compare(secondServer.name) == ComparisonResult.orderedAscending
        }
    }
    
    class private func sortServerListByDistance(_ serverList: [ServerListEntity]) -> [ServerListEntity] {
     
        return serverList.sorted { (firstServer, secondServer) -> Bool in
            return firstServer.distance <= secondServer.distance
        }
    }
}
