//
//  DecodableServiceProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation

protocol DecodableServiceProtocol {
    func authValue(data: Data) -> Result<AuthModel, Error>
    func serverValue(data: Data) -> Result<ServerModel, Error>
}
