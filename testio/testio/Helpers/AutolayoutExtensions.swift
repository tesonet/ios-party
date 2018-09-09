//
//  AutolayoutExtensions.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit
import Foundation

public extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> Self {
        self.priority = priority
        
        return self
    }
    
    func with(constant: CGFloat) -> Self {
        self.constant = constant
        
        return self
    }
}

public extension UIView {
    func constraint(edgesTo superview: UIView, priority: UILayoutPriority = .required, constant: CGFloat = 0) {
        var constraints = [NSLayoutConstraint]()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        constraints.append(self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant))
        constraints.append(self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant))
        constraints.append(self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant))
        constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant))
        
        NSLayoutConstraint.activate(constraints)
    }
}
