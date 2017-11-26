import Foundation

private let TokenValueKey = "token"

public struct Authorization: Parsable {
    let token: String
    
    public init?(data: Data) {
        do {
            guard let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : String],
                let fetchedToken = jsonSerialized[TokenValueKey] else {
                    return nil
            }
            token = fetchedToken
        } catch {
            return nil
        }
    }
}
