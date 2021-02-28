//
//  LocalStorageServiceProtocol.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ServerItemLocalRepositoryProtocol {
    func load(sortBy: ServerItemLocalRepositorySortOption, completion: ((Result<[DomainServerItem], LocalRepositoryError>) -> ())?)
    func save(items: [DomainServerItem], completion: ((Result<Void, LocalRepositoryError>) -> ())?)
    func clear()
}
