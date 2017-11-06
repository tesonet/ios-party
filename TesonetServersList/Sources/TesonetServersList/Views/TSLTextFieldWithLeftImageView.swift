//
//  TSLTextFieldWithLeftImageView.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

class TSLTextField: UITextField {
	
	var placeholderFont: UIFont = TSLScaledFont.defalut.font(forTextStyle: .callout) {
		didSet {
			if let placeholder = placeholder ?? attributedPlaceholder?.string {
				let attriutedString = attributedPlaceholder ?? NSAttributedString(string: placeholder)
				let mutableAttributedString = NSMutableAttributedString(attributedString: attriutedString)
				mutableAttributedString.addAttribute(.font,
																						 value: placeholderFont,
																						 range: NSRange(location: 0,
																														length: placeholder.count))
				self.attributedPlaceholder = attriutedString
			}
		}
	}
	
}

final class TSLTextFieldWithLeftImageView: TSLTextField {
	
	override final func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		let offset = UIOffset(horizontal: 15.0,
													vertical: 10.0)
		let imageViewSize: CGFloat = max(bounds.height - offset.vertical * 2, 0)
		
		// 7.0 is the distance from left view's right margin to TextFieldContentView used by iOS
		let origin: CGPoint = CGPoint(x: 7.0,
																	y: offset.vertical)
		let size: CGSize = CGSize(width: imageViewSize + offset.horizontal,
															height: imageViewSize)
		return CGRect(origin: origin,
									size: size)
		
	}
	
}
