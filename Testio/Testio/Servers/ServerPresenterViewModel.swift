//
//  ServerPresenterViewModel.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ServerResultsConsuming {
    
    var servers: AnyObserver<[TestioServer]> { get }
    
}

protocol ServerResultsPresenting {
    
    var serverResults: Driver<[TestioServer]> { get }
    
}

class ServerPresenterViewModel: ServerResultsConsuming, ServerResultsPresenting {

    var servers: AnyObserver<[TestioServer]> {
        return serversSubject.asObserver()
    }
    
    var serverResults: Driver<[TestioServer]> {
        return serversSubject.asDriver(onErrorJustReturn: [])
    }
    
    private let serversSubject = BehaviorSubject<[TestioServer]>(value: [])
    
}
