//
//  UIImageView_InitWithContentMode.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

extension UIImageView {
	
	convenience init(image: UIImage, contentMode: UIViewContentMode = .scaleAspectFit) {
		self.init(image: .some(image))
		self.contentMode = contentMode
		self.clipsToBounds = true
	}
	
}
