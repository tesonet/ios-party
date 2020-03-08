//
//  HighlightableButton.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

@IBDesignable
class HighlightableButton: UIButton {

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

  // override points
  func didInit() { }
  func updateHighlight() { }

}

final class ActionButton: HighlightableButton {

  override func didInit() {
    layer.cornerRadius = 5
  }

  override func updateHighlight() {
    backgroundColor = isHighlighted ? highlightColor : unhighlightColor
  }

}

final class PlainButton: HighlightableButton {

  override func updateHighlight() {
    tintColor = isHighlighted ? highlightColor : unhighlightColor
  }

}
