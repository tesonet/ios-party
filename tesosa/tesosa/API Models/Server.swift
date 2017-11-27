import Foundation

private let NameValueKey = "name"
private let DistanceValueKey = "distance"

public struct Server {
    let name: String
    let distance: Double
    
    public init?(data: Any) {
        guard let data = data as? [String: Any],
            let fetchedName = data[NameValueKey] as? String,
            let fetchedDistance = data[DistanceValueKey] as? Double else {
                return nil
        }
        name = fetchedName
        distance = fetchedDistance
    }
}

public struct Servers: Parsable {
    let servers: [Server]
    
    public init?(data: Data) {
        do {
            guard let serversDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any],
                let fetchedServers = serversDataArray.map({ Server(data: $0) }) as? [Server] else {
                    return nil
            }
            servers = fetchedServers
        } catch {
            return nil
        }
    }
}
