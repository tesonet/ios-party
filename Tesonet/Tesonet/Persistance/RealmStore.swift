import Realm
import RealmSwift

final class RealmStore {
    // Instances of Realm thread-contained.
    // This queue is created once, so it's guaranteed all Realm instances are handled in this queue
    private let realmQueue: DispatchQueue
    
    // Singelton
    static var shared = RealmStore()
    private init() {
        realmQueue = DispatchQueue(label: "com.tesonetparty.realm")
    }
    
    /**
     Persist array of Server objects.
     
     Before adding an array of Server objects to Realm database, we delete all previously added Server objects.
     Here every time new set of servers is generated, so we need fresh copy every time.
     If deletion fails - we return and do not add given array of server objects.
     
     Whole operation is performed on synchronous queue with the purpose of being able to use Realm results right
     after this metod call. With async call results would be unavailable right away since Realm still would be
     performing operation.

     - parameter items: array of Server objects to persist.
     */
    func add(items: [Server]) {
        realmQueue.sync {
            if let realm = try? Realm() {
                do {
                    try realm.write {
                        realm.deleteAll()
                    }
                } catch {
                    return
                }
                items.forEach { item in
                    try? realm.write {
                        realm.add(item.asRealm())
                    }
                }
            }
        }
    }
    
    /**
     Retrieve all Server objects.
     In case of error empty array is returned
     
     - returns: Persisted array of Server objects.
     */
    func retrieve() -> [Server] {
        var rmResults: Results<RMServer>?
        realmQueue.sync {
            if let realm = try? Realm() {
                rmResults = realm.objects(RMServer.self)
            }
        }
        
        var items = [Server]()
        guard let realmData = rmResults else {
            return items
        }
        realmData.forEach {
            items.append($0.asDomain())
        }
        
        return items
    }
}
