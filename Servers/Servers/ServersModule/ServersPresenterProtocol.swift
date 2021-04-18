//
//  ServerRouter.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import Foundation

protocol ServersPresenterProtocol {
    var servers: [ServerModel] { get }
    
    func getServers()
}
