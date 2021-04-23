//
//  UIViewController+extension.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 23.04.2021.
//

import UIKit

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
