// Created by Paulius Cesekas on 08/04/2019.

import Foundation
import RealmSwift

public protocol RealmStorable: Storable {
    init?(_ realmObject: Object)
    func toRealmObject() -> Object
    static func realmObjectType() -> Object.Type
}
