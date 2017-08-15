//
//  ServerListVM.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Foundation
import RxSwift

final class ServerListVM: NSObject {
    
    private let loadingVar = Variable<Bool>(true)
    var loading: Observable<Bool> { return loadingVar.asObservable() }
    
    private let serversVar = Variable<[ServerData]>([])
    var servers: Observable<[ServerData]> { return serversVar.asObservable() }
    
    func fetchServers() {
        loadingVar.value = true
        API.Servers.GetAll()
            .request()
            .do{ [weak self] _ in self?.loadingVar.value = false }
            .bind(to: serversVar)
            .addDisposableTo(rx_disposeBag)
    }
    
    func logOut(completion: ()->()) {
        API.Headers.clear()
        completion()
    }
}
