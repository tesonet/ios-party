//
//  SystemEnvironment.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 31.05.2021.
//

import Foundation
import CombineSchedulers

@dynamicMemberLookup
struct SystemEnvironment<Environment, Dependencies> {
    private let _dependencies: Dependencies
    let mainQueue: AnySchedulerOf<DispatchQueue>
    var environment: Environment
    
    private init(mainQueue: AnySchedulerOf<DispatchQueue>, dependencies: Dependencies, environment: Environment) {
        self.mainQueue = mainQueue
        self._dependencies = dependencies
        self.environment = environment
    }
    
    subscript<Dependency>(
        dynamicMember keyPath: KeyPath<Environment, Dependency>
    ) -> Dependency {
        get { self.environment[keyPath: keyPath] }
    }
    
    static func live(environment: Environment, dependencies: Dependencies) -> Self {
        Self(
            mainQueue: .main,
            dependencies: dependencies,
            environment: environment
        )
    }
    
    func create<NewEnvironment>(
        _ creator: @escaping (Dependencies) -> NewEnvironment
    ) -> SystemEnvironment<NewEnvironment, Dependencies> {
        .init(
            mainQueue: mainQueue,
            dependencies: _dependencies,
            environment: creator(_dependencies)
        )
    }
}

#if DEBUG
extension SystemEnvironment {
    static func mock(
        mainQueue: @escaping () -> AnySchedulerOf<DispatchQueue> = { fatalError() },
        environment: Environment,
        dependencies: Dependencies
    ) -> Self {
        Self(
            mainQueue: mainQueue(),
            dependencies: dependencies,
            environment: environment
        )
    }
}
#endif
