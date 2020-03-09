//
//  LoadingViewController.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {

  @IBOutlet weak var spinner: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!

  override func viewDidLoad() {

    super.viewDidLoad()

    let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
    rotate.fromValue = CGFloat(0)
    rotate.toValue = CGFloat.pi * -2
    rotate.duration = 1
    rotate.isCumulative = true
    rotate.repeatCount = .greatestFiniteMagnitude
    rotate.isRemovedOnCompletion = false

    spinner.layer.add(rotate, forKey: "spin")

  }

}
