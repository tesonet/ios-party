//
//  ViewModel.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Combine
import SwiftUI

protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input

    var state: State { get }
    func trigger(_ input: Input)
    func eraseToAnyViewModel() -> AnyViewModel<State, Input>
}

extension ViewModel {
    func eraseToAnyViewModel() -> AnyViewModel<State, Input> {
        AnyViewModel(self)
    }
}

extension AnyViewModel: Identifiable where State: Identifiable {
    var id: State.ID {
        state.id
    }
}

@dynamicMemberLookup
final class AnyViewModel<State, Input>: ViewModel {
    // MARK: Stored properties

    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void

    // MARK: Computed properties

    var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }

    var state: State {
        wrappedState()
    }

    // MARK: Methods

    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }

    // MARK: Initialization

    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        wrappedState = { viewModel.state }
        wrappedTrigger = viewModel.trigger
    }

    // MARK: Binding

    func binding<Value>(_ stateValue: KeyPath<State, Value>, with inputCase: @escaping (Value) -> Input) -> Binding<Value> {
        Binding<Value>(
            get: { self.state[keyPath: stateValue] },
            set: { self.trigger(inputCase($0)) }
        )
    }
}
