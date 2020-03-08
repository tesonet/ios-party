//
//  ContainerViewController.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

/**
 This view controller is inteded to use its entire safe area to present another view controller,
 and to animate transitions between them. This view controller may have have a common
 background that doesn't animate together with child view controller changes.
 */
class ContainerViewController: KeyboardSafeAreaViewController {

  private var currentChildVC: UIViewController!
  @IBOutlet weak var container: UIView!

  override func viewDidLoad() {
    currentChildVC = children[0]
  }

  func moveToNewVC(_ newVC: UIViewController, animation: Animation) {

    let oldVC = currentChildVC!
    let oldView = oldVC.view!
    currentChildVC = newVC

    oldVC.willMove(toParent: nil)
    addChild(newVC)

    let fromScale, toScale: CGFloat

    switch animation {
      case .shrink: (fromScale, toScale) = (1.2, 0.8)
      case .expand: (fromScale, toScale) = (0.8, 1.2)
    }

    let newView = newVC.view!
    newView.frame = container.bounds
    newView.transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
    newView.alpha = 0

    transition(from: oldVC, to: newVC, duration: 0.4, options: [], animations: {
      newView.transform = .identity
      newView.alpha = 1
      oldView.transform = CGAffineTransform(scaleX: toScale, y: toScale)
      oldView.alpha = 0
    }, completion: { (finished) in
      oldVC.removeFromParent()
      newVC.didMove(toParent: self)
    })

  }

  enum Animation {
    case shrink
    case expand
  }

}
