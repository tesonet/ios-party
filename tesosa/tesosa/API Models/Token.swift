import Foundation

public struct Authorization: Parsable {
    let token: String
    
    public init(data: Data) {
        do {
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            print(jsonSerialized ?? "")
        }  catch let error as NSError {
            print(error)
        }
    }
}
