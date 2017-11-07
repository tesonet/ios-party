//
//  UIImageView_InitWithContentMode.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

extension UIImageView {
	
	/// Returns an image view initialized with the specified `image`
	/// and `contentMode`.
	///
	/// - Parameters:
	///   - image: The initial image to display in the image view.
	///   - contentMode: A flag used to determine how a view lays out its content.
	///  Default value: `.scaleAspectFit`.
	convenience init(image: UIImage, contentMode: UIViewContentMode = .scaleAspectFit) {
		self.init(image: .some(image))
		self.contentMode = contentMode
		self.clipsToBounds = true
	}
	
}
