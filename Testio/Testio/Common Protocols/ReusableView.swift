//
//  ReusableView.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

protocol ReusableView where Self: UIView {
    
    static var reuseIdentifier: String { get }
    
}

extension ReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
