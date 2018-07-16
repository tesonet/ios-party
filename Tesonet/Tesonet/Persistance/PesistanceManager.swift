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
    
    func write(servers: [Server]) {
        NSKeyedArchiver.archiveRootObject(servers, toFile: "ServersData")
    }
    
    func read() -> [Server] {
        guard let serversData = NSKeyedUnarchiver.unarchiveObject(withFile: "ServersData") as? Data else {
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
    
    func write(servers: [Server]) {
        if let encoded = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(encoded, forKey: "ServersData")
        }
    }
    
    func read() -> [Server] {
        var servers = [Server]()
        if let serversData = UserDefaults.standard.value(forKey: "ServersData") as? Data {
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
