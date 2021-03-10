//
//  XibInstantiable.swift
//  Testio
//
//  Created by Andrii Popov on 3/9/21.
//

import UIKit

protocol XibInstantiable {}

extension XibInstantiable where Self: UIView {
  static func instantiate() -> Self {
    let bundle = Bundle(for: Self.self)
    let nibName = String(describing: Self.self)
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(withOwner: nil, options: nil).first as! Self
  }
}
