//
//  ServerListFetchBuilder.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

final class ServerListFetchBuilder: ServiceFactoryContainer {
    func view() -> ServerListFetchView {
        let viewModel = ServerListFetchViewModel(
            apiService: factory.apiService,
            repostory: factory.serverItemLocalRepository,
            configService: factory.configService
        )
        let view = ServerListFetchViewController(viewModel: viewModel)
        viewModel.delegate = view
        return  view
    }
}
