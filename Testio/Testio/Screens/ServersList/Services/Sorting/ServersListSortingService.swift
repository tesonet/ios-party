//
//  ServersListSortingService.swift
//  Testio
//
//  Created by Andrii Popov on 3/10/21.
//

import Foundation

struct ServersListSortingService: ServersListSortingServiceProtocol {
    
    func sort(_ servers: [Server], by sortingOption: SortingOption) -> [Server] {
        switch sortingOption {
        case .distance:
            return sortByDistance(servers)
        default:
            return sortAlphanumerically(servers)
        }
    }
    
    private func sortByDistance(_ servers: [Server]) -> [Server] {
        servers.sorted {
            $0.distance < $1.distance
        }
    }
    
    private func sortAlphanumerically(_ servers: [Server]) -> [Server] {
        servers.sorted {
            $0.name < $1.name
        }
    }
    
}
