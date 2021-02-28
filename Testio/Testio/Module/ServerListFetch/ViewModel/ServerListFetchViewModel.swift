//
//  ServerListFetchViewModel.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import Foundation

final class ServerListFetchViewModel {
    
    let apiService: ApiServiceProtocol
    let repostory: ServerItemLocalRepositoryProtocol
    let configService: ConfigServiceProtocol
    
    weak var delegate: ServerListFetchViewModelDelegate?
    
    var isLoading = false
    
    init(
        apiService: ApiServiceProtocol,
        repostory: ServerItemLocalRepositoryProtocol,
        configService: ConfigServiceProtocol
    ) {
        self.apiService = apiService
        self.repostory = repostory
        self.configService = configService
    }
}

extension ServerListFetchViewModel: ServerListFetchViewModelProtocol {
    func load() {
        guard !configService.isDataLoaded else {
            delegate?.didSaveItemsSuccessfully()
            return
        }
        
        guard !isLoading else {
            return
        }
        
        delegate?.didStartLoading()
        isLoading = true
        
        apiService.loadServers {[weak self] result in
            switch result {
            case let .success(items):
                self?.repostory.save(items: items) { result in
                    switch result {
                    case .success:
                        self?.configService.isDataLoaded = true
                        self?.delegate?.didSaveItemsSuccessfully()
                    case .failure:
                        self?.delegate?.didReceiveError(error: "Database error")
                    }
                }
            case let .failure(error):
                switch error {
                case .unauthorized:
                    self?.delegate?.didReceiveUnauthorized()
                default:
                    self?.delegate?.didReceiveError(error: "Server error")
                }
            }
            
            self?.isLoading = false
        }
    }
}
