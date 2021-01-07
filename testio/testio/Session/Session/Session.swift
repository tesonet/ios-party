
import Foundation


protocol Session {
    
    var token: String? { get }
    var isActive: Bool { get }
    func activate(with token: String)
    func deactivate()
}
