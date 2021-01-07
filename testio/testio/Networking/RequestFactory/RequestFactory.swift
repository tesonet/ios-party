
import Foundation
import Alamofire


protocol RequestFactory {
    
    func login(with username: String, password: String) -> DataRequest
    func servers() -> DataRequest
}
