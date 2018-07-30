    //
//  File.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
    
protocol ServerPersisting {
    
    func store(servers: [TestioServer]) -> Observable<[TestioServer]>
    var servers: Observable<[TestioServer]> { get }
    
}

class TestioServerPersistence: ServerPersisting {
    
    // On data sets of large numbers everything
    // in this class should be done in a background thread
    
    lazy var servers: Observable<[TestioServer]> = {
        return Observable<Results<TestioServer>>
            .create{ observer -> Disposable in
                do {
                    let realm = try Realm()
                    let servers: Results<TestioServer> = realm.objects(TestioServer.self)
                    observer.onNext(servers)
                    observer.onCompleted()
                } catch let error {
                    observer.onError(error)
                }
                return Disposables.create()
            }
            .map { Array($0) }
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
    }()
    
    func store(servers: [TestioServer]) -> Observable<[TestioServer]> {
        return Observable<[TestioServer]>
            .create { observer -> Disposable in
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(servers, update: true)
                        observer.onNext(servers)
                        observer.onCompleted()
                    }
                } catch let error {
                    observer.onError(error)
                }
                return Disposables.create()
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
    }
    
    func deleteServers() -> Observable<Void> {
        return Observable<Void>
            .create { observer -> Disposable in
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.deleteAll()
                        observer.onCompleted()
                    }
                } catch let error {
                    observer.onError(error)
                }
                return Disposables.create()
            }
    }
    
}
