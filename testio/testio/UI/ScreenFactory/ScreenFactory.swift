
import UIKit


protocol ScreenFactory {
    
    func makeLoginScreen() -> LoginViewController
    func makeServersScreen() -> ServersViewController
}
