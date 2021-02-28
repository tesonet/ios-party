//
//  ServerListBuilder.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

final class ServerListBuilder: ServiceFactoryContainer {
    func view() -> ServerListView {
        let viewModel = ServerListViewModel(
            repository: factory.serverItemLocalRepository,
            secureStorage: factory.secureStorageService,
            configService: factory.configService
        )
        
        let view = ServerListController(viewModel: viewModel)
        viewModel.delegate = view

        return view
    }
}
