import Foundation

enum PersistanceType {
    case userDefaultsPersistance
    case filePersistance
}

protocol Persistance {
    
    func write(servers: [Server])
    func read() -> [Server]
    
}

// MARK: File Persistance

class FilePersistance: Persistance {
    
    func write(servers: [Server]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(servers)
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            let url = documentDirectory.appendingPathComponent(String(describing: Server.self))
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read() -> [Server] {
        var servers = [Server]()
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            let url = documentDirectory.appendingPathComponent(String(describing: Server.self))
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            servers = try decoder.decode([Server].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return servers
    }
    
    
}

// MARK: User Defaults Persistance

// We don't want to save [Server] in UserDefaults -
// UserDefaults persistance type added just as another type of persistance in persistance layer
class UserDefaultsPersistance: Persistance {
    
    func write(servers: [Server]) {
        if let encoded = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(encoded, forKey: String(describing: Server.self))
        }
    }
    
    func read() -> [Server] {
        var servers = [Server]()
        if let serversData = UserDefaults.standard.value(forKey: String(describing: Server.self)) as? Data {
            let decoder = JSONDecoder()
            if let serversDecoded = try? decoder.decode([Server].self, from: serversData) as [Server] {
                servers = serversDecoded
            }
        }
        return servers
    }
    
}

// MARK: Realm Persistance
// TODO: Add class for Realm

// MARK: Persistance Factory

class PersistanceFactory {
    
    static func producePersistanceType(type: PersistanceType) -> Persistance {
        switch type {
        case .userDefaultsPersistance:
            return UserDefaultsPersistance()
        case .filePersistance:
            return FilePersistance()
        }
    }
    
}
