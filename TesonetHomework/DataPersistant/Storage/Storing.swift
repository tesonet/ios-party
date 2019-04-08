// Created by Paulius Cesekas on 01/04/2019.

import RxSwift

public protocol Storing {
    func save(_ storable: Storable) -> Observable<Void>
    func save(_ storables: [Storable]) -> Observable<Void>
    func delete(_ storable: Storable) -> Observable<Void>
    func deleteAll<T: Storable>(_ storableType: T.Type) -> Observable<Void>
    func fetch<T: Storable>(_ storableType: T.Type,
                            predicate: NSPredicate?,
                            sort: Sort?) -> Observable<[T]>
}
