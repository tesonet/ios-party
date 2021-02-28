//
//  ServerListViewModel.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import Foundation
import MapKit

final class ServerListViewModel {
    var items: [ServerListServerViewModel] = []
    
    weak var delegate: ServerListViewModelDelegate?
    
    let repository: ServerItemLocalRepositoryProtocol
    let secureStorage: SecureStorageServiceProtocol
    let configService: ConfigServiceProtocol
    
    let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        formatter.unitStyle = .abbreviated
        formatter.locale = Locale(identifier: "us")
        return formatter
    }()
    
    init(
        repository: ServerItemLocalRepositoryProtocol,
        secureStorage: SecureStorageServiceProtocol,
        configService: ConfigServiceProtocol
    ) {
        self.repository = repository
        self.secureStorage = secureStorage
        self.configService = configService
    }
}

extension ServerListViewModel: ServerListViewModelProtocol {
    func load(sortBy: ServerItemLocalRepositorySortOption) {
        repository.load(sortBy: sortBy) { [weak self, distanceFormatter] result in
            switch result {
            case let .success(domainItems):
                self?.items = domainItems.map { item in
                    ServerListServerViewModel(
                        name: item.name,
                        distance: distanceFormatter.string(fromDistance: CLLocationDistance(item.distance * 1000))
                    )
                }
                self?.delegate?.didLoadItems()
            case .failure:
                self?.delegate?.didReceiveError(error: "Database error")
            }
        }
    }
    
    func logout() {
        secureStorage.authToken = nil
        configService.isDataLoaded = false
        repository.clear()
        delegate?.didLogout()
    }
}
