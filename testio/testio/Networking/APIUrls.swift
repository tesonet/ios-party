
import Foundation


class APIUrls {
    
    static let shared = APIUrls()
    
    private var baseString = Config.current.baseAPIUrlString
    
    func tokens() -> URL {
        return url(withPath: "/tokens")
    }
    
    private func url(withPath path: String) -> URL {
        return URL(string: "\(baseString)\(path)")!
    }
}
