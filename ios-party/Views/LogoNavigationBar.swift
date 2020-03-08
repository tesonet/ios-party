//
//  LogoNavigationBar.swift
//  ios-party
//
//  Created by Joseph on 3/8/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class LogoNavigationBar: UINavigationBar {

  override func awakeFromNib() {
    super.awakeFromNib()
    setBackgroundImage(UIImage(), for: .default)
    shadowImage = UIImage()
  }

}
