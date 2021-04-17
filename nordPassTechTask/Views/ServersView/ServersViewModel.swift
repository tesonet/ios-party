//
//  ServerViewModel.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

final class ServersViewModel<S>: ViewModel where S: Scheduler {
    @Published var state: ServersState
    
    private let repository: ServersRepositoryProtocol
    private let scheduler: S
    private let store: ServersStoreProtocol
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(state: ServersState, with repository: ServersRepositoryProtocol, store: ServersStoreProtocol, on scheduler: S) {
        self.state = state
        self.repository = repository
        self.scheduler = scheduler
        self.store = store
    }
    
    func trigger(_ input: ServerInput) {
        switch input {
        case .initialFetch:
            
            store.load()
                .delay(for: .seconds(6), scheduler: DispatchQueue.global())
                .receive(on: scheduler)
                .catch { error -> Empty<[ServerDTO], Never> in
                    assert(false, "Loading from store: \(error)")
                    return Empty<[ServerDTO], Never>(completeImmediately: true)
                }
                .sink { [weak self] servers in
                    guard self?.state.servers.isEmpty != false, !servers.isEmpty else { return }
                    self?.state.servers = servers
                }
                .store(in: &bag)

            repository.getServers()
                .delay(for: .seconds(5), scheduler: DispatchQueue.global())
                .receive(on: scheduler)
                .catch { [weak self] error -> Empty<[ServerDTO], Never> in
                    print(error.localizedDescription)
                    guard let error = error as? NetworkError else {
                        self?.state.error = NetworkError.unknownError.alertError
                        return Empty<[ServerDTO], Never>(completeImmediately: true)
                    }
                    self?.state.error = error.alertError
                    return Empty<[ServerDTO], Never>(completeImmediately: true)
                }
                .flatMap { [weak self] servers -> AnyPublisher<Void, Error> in
                    guard let self = self else { return Empty<Void, Error>(completeImmediately: true).eraseToAnyPublisher() }
                    self.state.servers = servers
                    return self.store.save(servers)
                }
                .catch { [weak self] error -> Empty<Void, Never> in
                    assert(false, "Saving error: \(error)")
                    guard let error = error as? ServersJsonStoreError else {
                        self?.state.error = ServersJsonStoreError.unknownError.alertError
                        return Empty<Void, Never>(completeImmediately: true)
                    }
                    self?.state.error = error.alertError
                    return Empty<Void, Never>(completeImmediately: true)
                }
                .sink {}
                .store(in: &bag)
            
        case .updateIsOrderSheetPresented(let isPresented):
            state.isOrderSheetPresented = isPresented
        
        case .updateError(let error):
            state.error = error
        case .updateSortedBy(let sortBy):
            state.sortedBy = sortBy
            switch state.sortedBy {
            case .name:
                state.servers = state.servers.sorted(by: { $0.name > $1.name })
            case .distance:
                state.servers = state.servers.sorted(by: { $0.distance > $1.distance })
            default: break
            }
        }
    }
}

#if DEBUG
extension ServersState {
    static func mock(servers: [ServerDTO] = []) -> ServersState {
        ServersState(servers: servers, sortingOrder: .descending, sortedBy: .none, isOrderSheetPresented: false)
    }
}

extension ServersViewModel {
    static func mock(state: ServersState) -> ServersViewModel<ImmediateScheduler> {
        ServersViewModel<ImmediateScheduler>(state: state, with: ServersRepositoryProtocolMock(), store: ServersStoreProtocolMock(), on: ImmediateScheduler.shared)
    }
}
#endif
