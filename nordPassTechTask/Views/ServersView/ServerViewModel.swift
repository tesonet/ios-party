//
//  ServerViewModel.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

final class ServerViewModel<S>: ViewModel where S: Scheduler {
    @Published var state: ServersState
    
    private let repository: ServerRepositoryProtocol
    private let scheduler: S
    
    init(state: ServersState, with repository: ServerRepositoryProtocol, on scheduler: S) {
        self.state = state
        self.repository = repository
        self.scheduler = scheduler
    }
    
    func trigger(_ input: ServerInput) {
        switch input {
        case .updateIsOrderSheetPresented(let isPresented):
            state.isOrderSheetPresented = isPresented
        }
    }
}

#if DEBUG
extension ServersState {
    static func mock() -> ServersState {
        ServersState(servers: [], sortingOrder: .descending, sortingBy: .none, isOrderSheetPresented: false)
    }
}

extension ServerViewModel {
    static func mock(state: ServersState) -> ServerViewModel<ImmediateScheduler> {
        ServerViewModel<ImmediateScheduler>(state: .mock(), with: ServerRepositoryProtocolMock(), on: ImmediateScheduler.shared)
    }
}
#endif
