//
//  InfoListViewModel.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

final class ServersListViewModel: ServersListViewModelProtocol {

    private weak var coordinator: ServersListCoordinatorProtocol?
    private var servers = [Server]() {
        didSet {
            onUpdateServersList?()
        }
    }
    private let model: ServersListModel
    private let fetchingService: ServersListServiceProtocol
    private let sortingService: ServersListSortingServiceProtocol
    
    var onUpdateServersList: (() -> ())?
    
    var serversCount: Int {
        servers.count
    }
    
    init(model: ServersListModel, coordinator: ServersListCoordinatorProtocol, fetchingService: ServersListServiceProtocol, sortingService: ServersListSortingServiceProtocol) {
        self.model = model
        self.coordinator = coordinator
        self.fetchingService = fetchingService
        self.sortingService = sortingService
    }
    
    func start() {
        fetchServerList()
    }
    
    func server(at index: Int) -> Server {
        servers[index]
    }
    
    private func fetchServerList() {
        fetchingService.servers(token: model.authorizationData.token) { [weak self] result in
            switch result {
            case .success(let fetchedServers):
                self?.servers = fetchedServers
            case .failure(let error):
                self?.coordinator?.stop(reason: .error(error.description))
            }
        }
    }
}

//MARK: - UI events

extension ServersListViewModel {
    func displySortingOptions() {
        coordinator?.displaySortingOptions(model.sortingOptions) { [weak self] selectedSortingOption in
            guard let self = self else { return }
            self.servers = self.sortingService.sort(self.servers, by: selectedSortingOption)
        }
    }
    
    func logOut() {
        coordinator?.stop(reason: .logOut)
    }
}
