//
//  ServersViewRedux.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 27.05.2021.
//

import Combine
import ComposableArchitecture

private struct ServersSubscriptionId: Hashable {}
private struct FetchSubscriptionId: Hashable {}

enum ServersReducer {
    static let reducer = Reducer<ServersState, ServersAction, GlobalEnvironment<ServersEnvironment>> { state, action, environment in
        struct ServersSubscriptionId: Hashable {}
        
        switch action {
        case .orderSheetButtonTapped:
            func updateSorting(by sort: ServersState.SortedBy) -> ServersAction {
                guard sort != state.sortedBy else { return .setSortingOrder(state.sortingOrder.invert()) }
                return .setSortBy(sort)
            }
            
            state.orderSheet = ActionSheetState(
                title: TextState("Sort:"),
                buttons: [
                    .cancel(),
                    .default(.init("By Distance"), send: updateSorting(by: .distance)),
                    .default(.init("Alphanumerical"), send: updateSorting(by: .name)),
                ]
            )
            return .none
            
        case .orderSheetDismissed:
            state.orderSheet = nil
            return .none
            
        case .errorAlertReceived(let message, let actionMesage, let action):
            state.errorAlert = AlertState(
                title: TextState("Error"),
                message: TextState(message),
                dismissButton: .default(TextState(actionMesage), send: action)
            )
            return .none
            
        case .errorAlertDismissed:
            state.errorAlert = nil
            return .none
            
        case .setSortBy(let sortBy):
            state.sortedBy = sortBy
            return .none
            
        case .setSortingOrder(let sortingOrder):
            state.sortingOrder = sortingOrder
            return .none
            
        case .fetch:
            return environment.fetchServers()
                .receive(on: environment.mainQueue)
                .mapToNSError()
                .catchToVoidEffect()
                .map(ServersAction.fetchReceived)
                .cancellable(id: FetchSubscriptionId())
            
        case .fetchReceived(.success):
            return .none
            
        case .fetchReceived(.failure(let error)):
            switch error {
            case let networkError as NetworkError where networkError == .unathorized:
                return Effect(value: .errorAlertReceived(message: "Token has expired", actionMessage: "Logout", action: .logout))
            default:
                return Effect(value: .errorAlertReceived(message: error.localizedDescription, actionMessage: "Retry", action: .fetch))
            }
            
        case .serversReceived(let servers):
            state.servers = servers
            return .none

        case .logout:
            return .none
        }
    }
    .lifecycle(
        onAppear: { environment in
            let serversSubscription = environment.getServers()
                .receive(on: environment.mainQueue)
                .eraseToEffect()
                .map(ServersAction.serversReceived)
                .cancellable(id: ServersSubscriptionId())
            let fetch = Effect<ServersAction, Never>(value: ServersAction.fetch)
            return .merge(
                serversSubscription,
                fetch
            )
        },
        onDisappear: { _ in
            return .merge(
                .cancel(id: ServersSubscriptionId()),
                .cancel(id: FetchSubscriptionId())
            )
            
        }
    )
}
