//
//  ServerListNavigationController.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class ServerListNavigationController: UINavigationController {
    
    enum Constants {
        static var color: UIColor {
            UIColor(named: "navGray")!
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Constants.color
    }
}
