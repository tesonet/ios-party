//
//  BaseView.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import UIKit

protocol BaseView: class, Presentable {}

protocol Presentable {
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController {
        return self
    }
}
