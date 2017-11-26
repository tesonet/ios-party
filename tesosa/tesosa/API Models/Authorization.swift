import Foundation

private let TokenValueKey = "token"

public struct Authorization: Parsable {
    let token: String
    
    public init?(data: Data) {
        do {
            if let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : String],
                let fetchedToken = jsonSerialized[TokenValueKey] {
                token = fetchedToken
            } else {
                return nil
            }
        }  catch let error as NSError {
            return nil
        }
    }
}
