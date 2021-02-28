//
//  TestioLocalStorageTests.swift
//  TestioLocalStorageTests
//
//  Created by Claus on 28.02.21.
//

import XCTest
import CoreData
@testable import Testio

class TestioLocalStorageTests: XCTestCase {

    var repository: ServerItemLocalRepositoryProtocol!
    
    let testItems: [DomainServerItem] = [
        .init(name: "London", distance: 100),
        .init(name: "Paris", distance: 200),
        .init(name: "New York", distance: 300)
    ]
    
    override func setUpWithError() throws {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let modelURL = Bundle(for: AppDelegate.self).url(forResource: "Testio", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        let container = NSPersistentContainer(
              name: "Testio",
              managedObjectModel: model
        )
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        repository = ServerItemLocalRepository(container: container)
    }

    override func tearDownWithError() throws {
        repository = nil
    }

    func testSaveData() throws {
        let promise = expectation(description: "Test data saving")

        repository.save(items: testItems) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("Data not saved")
            }

            promise.fulfill()
        }

        wait(for: [promise], timeout: 1)
    }
    
    func testLoadData() throws {
        let promise = expectation(description: "Test data loading")

        repository.save(items: testItems) { [repository, testItems] result in
            switch result {
            case .success:
                repository?.load(sortBy: .name) { result in
                    switch result {
                    case let .success(items):
                        XCTAssert(items.count == testItems.count)
                    case .failure:
                        XCTFail("Data not loaded")
                    }
                    
                    promise.fulfill()
                }
            case .failure:
                XCTFail("Data not saved")
                promise.fulfill()
            }
        }

        wait(for: [promise], timeout: 1)
    }

}
