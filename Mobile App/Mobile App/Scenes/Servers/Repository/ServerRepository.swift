//
//  ServerRepository.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ServerRepository: NSObject {
    
    private let itemsVar = Variable<[Server]>([])
    var items: Driver<[Server]> { return itemsVar.asDriver() }
    
    override init() {
        super.init()
        fetch()
    }
    
    private func fetch() {
        API.Servers.GetAll()
            .request()
            .subscribe(onSuccess: { [weak self] items in
                self?.itemsVar.value = items
            })
            .disposed(by: rx.disposeBag)
    }

}
