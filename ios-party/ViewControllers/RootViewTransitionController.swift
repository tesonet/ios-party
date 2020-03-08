//
//  RootViewTransitionController.swift
//  ios-party
//
//  Created by Joseph on 3/8/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

struct RootViewTransitionController {

  enum Animation {
    case none
    case uncoverSlideDown
    case coverSlideUp
  }

  static func switchViewController(_ newVC: UIViewController, animation: Animation) {

    guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }

    let oldVC = window.rootViewController
    window.rootViewController = newVC

    if animation == .none { return }
    guard let oldView = oldVC?.view else { return }

    if animation == .uncoverSlideDown {

      window.addSubview(oldView)

      UIView.animate(withDuration: 0.6, animations: {
        oldView.frame.origin.y = window.bounds.size.height
      }, completion: { (finished) in
        oldView.removeFromSuperview()
      })

    } else if animation == .coverSlideUp {

      window.insertSubview(oldView, at: 0)
      newVC.view.frame.origin.y = window.bounds.size.height

      UIView.animate(withDuration: 0.6, animations: {
        newVC.view.frame.origin.y = 0
      }, completion: { (finished) in
        oldView.removeFromSuperview()
      })

    }


  }

}
