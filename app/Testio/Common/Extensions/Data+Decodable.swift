//
//  Data+Decodable.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import Foundation

extension Data {
    func decode<T>(_ type: T.Type) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(type, from: self)
        } catch {
            print("Decoder error: \(error.localizedDescription)")
            return nil
        }
    }
}
