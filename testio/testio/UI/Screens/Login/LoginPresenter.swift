
import Foundation


protocol LoginPresenter: class {
    
    func presentSuccess()
    func presentError(_ error: Error)
}
