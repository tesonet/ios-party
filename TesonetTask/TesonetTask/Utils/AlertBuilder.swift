//
//  AlertBuilder.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

struct AlertStyle {
    var title: String?
    var description: String?
    var style: UIAlertController.Style
    
    private init(title: String? = nil, description: String? = nil, style: UIAlertController.Style = .alert) {
        self.title = title
        self.description = description
        self.style = style
    }
    
    static func warning(with message: String) -> AlertStyle {
        return AlertStyle(title: "Ups!", description: message)
    }
    
    static var actionSheet: AlertStyle {
        return AlertStyle(style: .actionSheet)
    }
}

struct AlertBuilder {
    // MARK: - Properties
    private var alert: UIAlertController?

    // MARK: - Public Instance Methods
    /// Creates instance of alert controller
    @discardableResult private mutating func styled(with style: AlertStyle) -> AlertBuilder {
        alert = UIAlertController(title: style.title,
                                  message: style.description,
                                  preferredStyle: style.style)
        alert?.view.tintColor = UIColor.blue
        return self
    }

    /// Adds action to alert controller
    @discardableResult private func addAction(title: String,
                                              style: UIAlertAction.Style = .default,
                                              preferred: Bool = false,
                                              handler: (() -> Void)? = nil) -> AlertBuilder {
        
        let action = UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        })
        
        alert?.addAction(action)
        
        if preferred {
            alert?.preferredAction = action
        }
        
        return self
    }

    /// Returns configured alertController
    private func build() -> UIAlertController {
        guard let alert = alert else {
            fatalError("Trying to use variable before being initialized")
        }
        return alert
    }
    
    static func warning(with message: String) -> UIAlertController {
        var builder = AlertBuilder()
        return builder.styled(with: .warning(with: message))
                      .addAction(title: "OK")
                      .build()
    }
    
    static func chooseSortOption(distance: @escaping () -> Void, alphabetically: @escaping () -> Void) -> UIAlertController {
        var alertBuilder = AlertBuilder()
        return alertBuilder.styled(with: AlertStyle.actionSheet)
                           .addAction(title: "By Distance", handler: distance)
                           .addAction(title: "Alphanumerical", handler: alphabetically)
                           .addAction(title: "Cancel", style: .cancel)
                           .build()
    }

}
