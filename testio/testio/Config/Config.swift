
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


class DevelopmentConfig: Configuration {
    
    let baseAPIUrlString = "http://playground.tesonet.lt/v1"
}


class ProductionConfig: Configuration {
    
    let baseAPIUrlString = "http://playground.tesonet.lt/v1"
}
