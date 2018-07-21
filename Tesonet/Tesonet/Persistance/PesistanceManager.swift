import Foundation

enum PersistanceType {
    case userDefaultsPersistance
    case filePersistance
}

protocol Persistance {
    
    func write<T: Codable>(items: [T])
    func read<T: Codable>() -> [T]
    
}

// MARK: File Persistance

class FilePersistance: Persistance {
    
    func write<T: Codable>(items: [T]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            let url = documentDirectory.appendingPathComponent(String(describing: T.self))
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read<T: Codable>() -> [T] {
        var items = [T]()
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            let url = documentDirectory.appendingPathComponent(String(describing: T.self))
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            items = try decoder.decode([T].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return items
    }
    
}

// MARK: User Defaults Persistance

// We don't want to save [Server] in UserDefaults -
// UserDefaults persistance type added just as another type of persistance in persistance layer
class UserDefaultsPersistance: Persistance {
    
    func write<T: Codable>(items: [T]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: String(describing: T.self))
        }
    }
    
    func read<T: Codable>() -> [T] {
        var items = [T]()
        if let itemsData = UserDefaults.standard.value(forKey: String(describing: T.self)) as? Data {
            let decoder = JSONDecoder()
            if let itemsDecoded = try? decoder.decode([T].self, from: itemsData) {
                items = itemsDecoded
            }
        }
        return items
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
