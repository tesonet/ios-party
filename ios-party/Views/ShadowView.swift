//
//  ShadowView.swift
//  ios-party
//
//  Created by Joseph on 3/8/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

@IBDesignable
final class ShadowView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    didInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    didInit()
  }

  private func didInit() {
    layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
    layer.shadowOffset = .zero
    layer.shadowOpacity = 0.3
    layer.shadowRadius = 15
  }

}
