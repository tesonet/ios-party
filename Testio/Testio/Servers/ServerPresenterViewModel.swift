//
//  ServerPresenterViewModel.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift

protocol ServerResultsConsuming {
    
    var servers: AnyObserver<[TestioServer]> { get }
    
}

class ServerPresenterViewModel: ServerResultsConsuming {
    
    var servers: AnyObserver<[TestioServer]> {
        return serversSubject.asObserver()
    }
    
    private let serversSubject = BehaviorSubject<[TestioServer]>(value: [])
    
}
