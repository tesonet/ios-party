//
//  LoadingViewModel.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift

class LoadingViewModel {

    private let serverRetriever: ServersRetrievingType
    private let promptCoordinator: PromptCoordinatingType
    private let token: TestioToken

    init(token: TestioToken,
         serverRetriever: ServersRetrievingType,
         promptCoordinator: PromptCoordinatingType) {
        self.serverRetriever = serverRetriever
        self.promptCoordinator = promptCoordinator
        self.token = token
    }
    
}
