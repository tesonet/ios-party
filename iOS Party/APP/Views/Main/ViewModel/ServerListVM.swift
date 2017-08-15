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
    
    private let loadingVar = Variable<Bool>(false)
    var loading: Observable<Bool> { return loadingVar.asObservable() }
    
}
