//
//  RootViewController.swift
//  Testio
//
//  Created by Claus on 28.02.21.
//

import UIKit

class RootViewController: UIViewController {
    override var childForStatusBarStyle: UIViewController? {
        return children.first
    }
}

