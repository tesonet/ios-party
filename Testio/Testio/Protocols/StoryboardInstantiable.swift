//
//  StoryboardInstantiable.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

protocol StoryboardInstantiable {}

extension StoryboardInstantiable where Self: UIViewController {
  static func instantiate() -> Self {
    let storyboardName = String(describing: Self.self)
    return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! Self
  }
}
