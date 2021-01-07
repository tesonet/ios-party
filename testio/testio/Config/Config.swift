
import UIKit


protocol Configuration {
    
    var baseAPIUrlString: String { get }
}


class Config {
    
    class var current: Configuration {
        switch Environment.current() {
        case .development:
            return DevelopmentConfig()
        case .release:
            return ProductionConfig()
        }
    }
}
