//
//  MainStoryboardController.swift
//  ios-party
//
//  Created by Joseph on 3/8/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class MainStoryboardController {

  enum Animation {
    case none
    case uncoverSlideDown
    case coverSlideUp
  }

  static let shared = MainStoryboardController()

  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let window = UIWindow(frame: UIScreen.main.bounds)

  func switchToSplashViewController() {
    switchViewController("splash", animation: .coverSlideUp)
  }

  func switchToServerListViewController() {
    switchViewController("listNav", animation: .uncoverSlideDown)
  }

  func switchViewController(_ storyboardID: String, animation: Animation) {

    let newVC = storyboard.instantiateViewController(withIdentifier: storyboardID)

    let oldVC = window.rootViewController
    window.rootViewController = newVC

    if animation == .none { return }
    guard let oldView = oldVC?.view else { return }

    if animation == .uncoverSlideDown {

      self.window.addSubview(oldView)

      UIView.animate(withDuration: 0.6, animations: {
        oldView.frame.origin.y = self.window.bounds.size.height
      }, completion: { (finished) in
        oldView.removeFromSuperview()
      })

    } else if animation == .coverSlideUp {

      self.window.insertSubview(oldView, at: 0)
      newVC.view.frame.origin.y = self.window.bounds.size.height

      UIView.animate(withDuration: 0.6, animations: {
        newVC.view.frame.origin.y = 0
      }, completion: { (finished) in
        oldView.removeFromSuperview()
      })

    }


  }

}
