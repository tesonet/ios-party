import Foundation

struct Server {
    let name: String
    let distance: Int
}

struct Servers {
    let all: [Server]
    
    init(json: [[String: Any]]) {
        var all = [Server]()
        
        for serverJSON in json {
            if let name = serverJSON["name"] as? String,
               let distance = serverJSON["distance"] as? Int {
                all.append(Server(name: name, distance: distance))
            }
        }
        
        self.all = all
    }
}
