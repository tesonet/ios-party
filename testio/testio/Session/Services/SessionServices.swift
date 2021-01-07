
import Foundation


protocol SessionServices {
    
    var auth: AuthService { get }
    var servers: ServersService { get }
}
