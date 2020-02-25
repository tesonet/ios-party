//
//  Storyboard+Loader.swift
//  Tesonet
//

import UIKit

enum Storyboard: String {
    case main = "Main"
}

func className(classType: AnyClass) -> String {
    let name = classType.description()
    if let nameStripped = name.components(separatedBy: ".").last {
        return nameStripped
    } else {
        return name
    }
}

extension UIStoryboard {
    convenience init(_ storyboard: Storyboard) {
        self.init(name: storyboard.rawValue, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(for vcClass: T.Type) -> T {
        let name = className(classType: vcClass)
        guard
            let vc = self.instantiateViewController(withIdentifier: name) as? T
            else { fatalError("Cannot instantiate view controller with \"\(name)\" reuse identifier") }
        return vc
    }

    func instantiateNavController<T: UIViewController>(for vcClass: T.Type) -> UINavigationController {
        let name = className(classType: vcClass)
        guard
            let vc = self.instantiateViewController(withIdentifier: name) as? UINavigationController
            else { fatalError("Cannot instantiate nav controller with \"\(name)\" reuse identifier") }
        return vc
    }
}
