// Created by Paulius Cesekas on 02/04/2019.

import UIKit

protocol Navigatable {
    var rootNavigationController: UINavigationController { get }
}

extension Navigatable {
    var rootNavigationController: UINavigationController {
        return Application.shared.rootNavigationController
    }
}
