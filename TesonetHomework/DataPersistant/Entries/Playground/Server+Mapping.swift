// Created by Paulius Cesekas on 01/04/2019.

import Domain
import RealmSwift

extension Server: Storable { }

extension Server: RealmStorable {
    public func toRealmObject() -> Object {
        let server = ServerRealmObject()
        server.name = name
        server.distance = distance
        return server
    }
    
    public init?(_ realmObject: Object) {
        guard let server = realmObject as? ServerRealmObject else {
            return nil
        }
        
        self.init(
            name: server.name,
            distance: server.distance)
    }
    
    public static func realmObjectType() -> Object.Type {
        return ServerRealmObject.self
    }
}

class ServerRealmObject: Object, ToStorable {
    @objc dynamic var name: String = ""
    @objc dynamic var distance: Int = 0

    func toStorable() -> Storable? {
        return Server(
            name: name,
            distance: distance)
    }
}
