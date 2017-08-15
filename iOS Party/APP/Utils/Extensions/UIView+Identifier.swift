//
//  UIView+Identifier.swift
//
//  Credit: https://www.natashatherobot.com/swift-3-0-refactoring-cues/
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableViewCell: ReusableView { }
