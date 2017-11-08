//
//  UIView+CornerRadius.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

extension UIView {
	
	@IBInspectable final var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set(newCornerRadius) {
			updateCornerRadius(to: newCornerRadius)
		}
	}
	
	private func updateCornerRadius(to newCornerRadius: CGFloat) {
		layer.cornerRadius = newCornerRadius
	}
	
}
