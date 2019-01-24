import RealmSwift
import Realm

final class RMServer: Object {
    var distance = RealmOptional<Int>()
    @objc dynamic var name: String?
}

extension RMServer {
    func asDomain() -> Server {
        return Server(distance: distance.value, name: name)
    }
}

extension Server {
    func asRealm() -> RMServer {
        return RMServer.build { object in
            object.distance.value = distance
            object.name = name
        }
    }
}
