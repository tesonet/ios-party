import Foundation

enum PersistanceType {
    case userDefaultsPersistance
    case diskPersistance
}

protocol Persistance {
    
    func write(servers: [Server])
    func read() -> [Server]
    
}

// MARK: Disk Persistance

class DiskPersistance: Persistance {
    
    fileprivate let serversDataFileName = "ServersData"
    
    func write(servers: [Server]) {
        NSKeyedArchiver.archiveRootObject(servers, toFile: serversDataFileName)
    }
    
    func read() -> [Server] {
        guard let serversData = NSKeyedUnarchiver.unarchiveObject(withFile: serversDataFileName) as? Data else {
            return [Server]()
        }
        
        var servers = [Server]()
        let decoder = JSONDecoder()
        if let serversDecoded = try? decoder.decode(Array.self, from: serversData) as [Server] {
            servers = serversDecoded
        }
        return servers
    }
    
}

// MARK: User Defaults Persistance

class UserDefaultsPersistance: Persistance {
    
    fileprivate let serversDataKey = "ServersDataKey"
    
    func write(servers: [Server]) {
        if let encoded = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(encoded, forKey: serversDataKey)
        }
    }
    
    func read() -> [Server] {
        var servers = [Server]()
        if let serversData = UserDefaults.standard.value(forKey: serversDataKey) as? Data {
            let decoder = JSONDecoder()
            if let serversDecoded = try? decoder.decode([Server].self, from: serversData) as [Server] {
                servers = serversDecoded
            }
        }
        return servers
    }
    
}

// MARK: Realm Persistance
// TODO: Add operations with Realm

// MARK: Persistance Factory

class PersistanceFactory {
    
    static func producePersistanceType(type: PersistanceType) -> Persistance {
        switch type {
        case .userDefaultsPersistance:
            return UserDefaultsPersistance()
        case .diskPersistance:
            return DiskPersistance()
        }
    }
    
}
