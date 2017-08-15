//
//  File.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Foundation
import RxSwift

//Why is this not a struct? And why LoginVM inherits NSObject? 
//Long story short, because I want to use NSObject extension from NSObject+Rx.swift.
//Although it could be avoided.

final class LoginVM: NSObject {
    
    private let loadingVar = Variable<Bool>(false)
    var loading: Observable<Bool> { return loadingVar.asObservable() }
    
    func login(username: String, password: String, completion: @escaping ()->()) {
        loadingVar.value = true
        API.Authentication.Login(with: username, and: password)
            .request()
            .do{ [weak self] _ in self?.loadingVar.value = false }
            .subscribe(onNext: { auth in
                API.Headers.authorize(token: auth.token)
                completion()
            })
            .addDisposableTo(rx_disposeBag)
    }

}
