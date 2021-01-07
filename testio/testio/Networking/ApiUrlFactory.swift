
import Foundation


class ApiUrlFactory {
    
    static let shared = ApiUrlFactory()
    
    private var baseString = Config.current.baseAPIUrlString
    
    
    // MARK: - Public
    func tokens() -> URL {
        return url(withPath: "/tokens")
    }
    
    func servers() -> URL {
        return url(withPath: "/servers")
    }
    
    
    // MARK: - Private
    private func url(withPath path: String) -> URL {
        return URL(string: "\(baseString)\(path)")!
    }
}
