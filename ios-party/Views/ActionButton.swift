//
//  ActionButton.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

@IBDesignable
class ActionButton: UIButton {

  @IBInspectable var highlightColor: UIColor? {
     didSet { updateHighlight() }
   }

  @IBInspectable var unhighlightColor: UIColor? {
    didSet { updateHighlight() }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    didInit()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    didInit()
  }

  private func didInit() {
    layer.cornerRadius = 5
  }

  override var isHighlighted: Bool {
    didSet {
      if oldValue && !isHighlighted { // only animate unhighlight
        UIView.animate(
          withDuration: 0.25,
          delay: 0,
          options: .allowUserInteraction,
          animations: self.updateHighlight)
      } else {
        updateHighlight()
      }
    }
  }

  private func updateHighlight() {
    backgroundColor = isHighlighted ? highlightColor : unhighlightColor
  }

}
