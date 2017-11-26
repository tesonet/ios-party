import Foundation
import UIKit

extension UIAlertController {
    static func presentErrorAlert(error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: LocalizationService.localized(key: "confirmation_button_title"), style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        present(alertController: alertController)
    }
    
    static private func present(alertController: UIAlertController) {
        let appDelegate = UIApplication.shared.delegate
        let controller = appDelegate?.window??.rootViewController
        controller?.present(alertController, animated: true, completion: nil)
    }
}
