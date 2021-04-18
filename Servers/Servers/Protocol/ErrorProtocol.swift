//
//  ErrorProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

protocol ErrorProtocol {
    func present(error: Error)
}

extension UIViewController: ErrorProtocol {
    func present(error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
