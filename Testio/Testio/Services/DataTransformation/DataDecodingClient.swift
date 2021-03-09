//
//  DataTransformingClient.swift
//  Testio
//
//  Created by Andrii Popov on 3/8/21.
//

import Foundation

struct DataDecodingClient {
    func value<T: Decodable>(from data: Data) -> Result<T, DataDecodingError> {
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(T.self, from: data)
            return .success(value)
        } catch {
            return .failure(.generic(error.localizedDescription))
        }
    }
}
