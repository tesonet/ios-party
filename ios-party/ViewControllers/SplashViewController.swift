//
//  SplashViewController.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class SplashViewController: ContainerViewController {

  func goToLoad() {
    if let sb = storyboard {
      moveToNewVC(sb.instantiateViewController(withIdentifier: "load"))
    }
  }

}
