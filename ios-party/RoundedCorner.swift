//
//  RoundedCorner.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class RoundedCornerView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    didInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    didInit()
  }

  private func didInit() {
    layer.cornerRadius = 5
  }

}

final class RoundedCornerButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    didInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    didInit()
  }

  private func didInit() {
    layer.cornerRadius = 5
  }

}
