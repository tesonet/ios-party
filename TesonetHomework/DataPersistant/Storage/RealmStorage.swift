// Created by Paulius Cesekas on 07/04/2019.

import Foundation
import RxSwift
import RealmSwift

public final class RealmStorage {
    // MARK: - Variables
    private let config: StorageConfig
    private var realm: Realm?
    
    // MARK: - Methods -
    public init(config: StorageConfig) {
        self.config = config
        setupRealm()
    }
    
    private func setupRealm() {
        var realmConfig = Realm.Configuration()
        if let path = config.path {
            realmConfig.fileURL = URL(fileURLWithPath: path)
        }
        do {
            realm = try Realm(configuration: realmConfig)
        } catch {
            print("Error - \(error)")
        }
    }
    
    fileprivate func safeWrite(_ block: ((Realm) -> Void)) throws {
        guard let realm = self.realm else {
            throw StoringError.storageIsNotConfigured
        }
        
        if realm.isInWriteTransaction {
            block(realm)
        } else {
            try realm.write({
                block(realm)
            })
        }
    }
}

// MARK: - Storing
extension RealmStorage: Storing {
    public func save(_ storable: Storable) -> Observable<Void> {
        return Observable<Void>.create { [unowned self] (observer) -> Disposable in
            do {
                try self.safeWrite({ (realm) in
                    guard let realmStorable = storable as? RealmStorable else {
                        observer.on(.error(StoringError.entryIsNotSupportedForSelectedStorage))
                        return
                    }
                    
                    let realmObject = realmStorable.toRealmObject()
                    realm.add(realmObject)
                    observer.onNext(())
                    observer.onCompleted()
                })
            } catch {
                observer.on(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func save(_ storables: [Storable]) -> Observable<Void> {
        return Observable<Void>.create { [unowned self] (observer) -> Disposable in
            do {
                try self.safeWrite({ (realm) in
                    guard let realmStorables = storables as? [RealmStorable] else {
                        observer.on(.error(StoringError.entryIsNotSupportedForSelectedStorage))
                        return
                    }

                    let realmObjects = realmStorables.compactMap({ $0.toRealmObject() })
                    realm.add(realmObjects)
                    observer.onNext(())
                    observer.onCompleted()
                })
            } catch {
                observer.on(.error(error))
            }

            return Disposables.create()
        }
    }

    public func delete(_ storable: Storable) -> Observable<Void> {
        return Observable<Void>.create { [unowned self] (observer) -> Disposable in
            do {
                try self.safeWrite({ (realm) in
                    guard let realmStorable = storable as? RealmStorable else {
                        observer.on(.error(StoringError.entryIsNotSupportedForSelectedStorage))
                        return
                    }

                    let realmObject = realmStorable.toRealmObject()
                    realm.delete(realmObject)
                    observer.onNext(())
                    observer.onCompleted()
                })
            } catch {
                observer.on(.error(error))
            }

            return Disposables.create()
        }
    }

    public func deleteAll<T: Storable>(_ storableType: T.Type) -> Observable<Void> {
        return Observable<Void>.create { [unowned self] (observer) -> Disposable in
            do {
                try self.safeWrite({ (realm) in
                    guard let realmStorableType = storableType as? RealmStorable.Type else {
                        observer.on(.error(StoringError.entryIsNotSupportedForSelectedStorage))
                        return
                    }

                    let realmObjectType = realmStorableType.realmObjectType()
                    let realmObjects = realm.objects(realmObjectType)
                    for realmObject in realmObjects {
                        realm.delete(realmObject)
                    }
                    observer.onNext(())
                    observer.onCompleted()
                })
            } catch {
                observer.on(.error(error))
            }

            return Disposables.create()
        }
    }

    public func fetch<T: Storable>(_ storableType: T.Type, predicate: NSPredicate?, sort: Sort?) -> Observable<[T]> {
        return Observable<[T]>.create { [unowned self] (observer) -> Disposable in
            guard let realm = self.realm else {
                observer.onError(StoringError.storageIsNotConfigured)
                return Disposables.create()
            }
            guard let realmStorableType = storableType as? RealmStorable.Type else {
                observer.on(.error(StoringError.entryIsNotSupportedForSelectedStorage))
                return Disposables.create()
            }

            let realmObjectType = realmStorableType.realmObjectType()
            var realmObjects = realm.objects(realmObjectType)
            if let predicate = predicate {
                realmObjects = realmObjects.filter(predicate)
            }
            if let sort = sort {
                realmObjects = realmObjects.sorted(
                    byKeyPath: sort.key,
                    ascending: sort.ascending)
            }
            guard let entries = try? realmObjects.compactMap({ (realmObject) -> T? in
                guard let toStorable = realmObject as? ToStorable,
                    let entry = toStorable.toStorable() as? T else {
                        throw StoringError.entryIsNotSupportedForSelectedStorage
                }

                return entry
            }) else {
                observer.on(.error(StoringError.entryIsNotSupportedForSelectedStorage))
                return Disposables.create()
            }

            observer.onNext(entries)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
