//
//  UIImage+Resize.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

extension UIImage {
	
	func scaled(changingHeightTo height: CGFloat) -> UIImage? {
		
		let size = self.size
		
		let ratio: CGFloat = height / size.height
		
		let newSize: CGSize = CGSize(width: size.width * ratio,
																 height: size.height * ratio)
		
		let rect = CGRect(origin: .zero, size: newSize)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
		
	}
	
}
