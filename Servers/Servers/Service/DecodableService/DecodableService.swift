//
//  AuthDataDecodableService.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation

class DecodableService: DecodableServiceProtocol {
    
    func authValue(data: Data) -> Result<AuthModel, Error> {
        return decode(data: data)
    }
    
    func serverValue(data: Data) -> Result<[ServerModel], Error> {
        return decode(data: data)
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, Error> {
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(T.self, from: data)
            return .success(value)
        } catch let error {
            return .failure(error)
        }
    }
}
