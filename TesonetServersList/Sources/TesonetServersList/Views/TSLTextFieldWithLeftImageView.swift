//
//  TSLTextFieldWithLeftImageView.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

/// Text field with an image on the left side.
final class TSLTextFieldWithLeftImageView: UITextField {
	
	override final func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		
		/// Offset for the left view from the top and the bottom of `TextFieldContentView`.
		let verticalOffset: CGFloat = 10.0
		
		/// Left view height.
		let leftViewHeight: CGFloat = max(bounds.height - verticalOffset * 2, 0)
		
		/// Additional left view width to make bigger distance from edges for the image.
		let additionalLeftViewWidth: CGFloat = 15.0
		
		// 7.0 is the distance from left view's right margin to TextFieldContentView used by iOS
		let origin: CGPoint = CGPoint(x: 7.0,
																	y: verticalOffset)
		let size: CGSize = CGSize(width: leftViewHeight + additionalLeftViewWidth,
															height: leftViewHeight)
		return CGRect(origin: origin,
									size: size)
		
	}
	
}
