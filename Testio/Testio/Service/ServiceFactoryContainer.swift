//
//  ServiceFactoryContainer.swift
//  Testio
//
//  Created by Claus on 28.02.21.
//

import Foundation

class ServiceFactoryContainer {
    
    let factory: ServiceFactoryProtocol
    
    init(factory: ServiceFactoryProtocol) {
        self.factory = factory
    }
}
