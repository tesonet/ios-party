
import Foundation


enum EnvironmentType {
    
    case development
    case release
}


struct Environment {
    
    static func current() -> EnvironmentType {
        var env: EnvironmentType!
        
        #if DEVELOPMENT_ENVIRONMENT
        env = .development
        #endif
        
        #if RELEASE_ENVIRONMENT
        env = .release
        #endif
        
        return env
    }
}
