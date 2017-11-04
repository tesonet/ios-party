//
//  String+Localized.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

extension String {
	
	var localized: String {
		return self.localized(using: "Localized", in: .main)
	}
	
	func localized(
		using tableName: String,
		in bunlde: Bundle = .main)
		-> String
	{
		return NSLocalizedString(self,
														 tableName: tableName,
														 bundle: bunlde,
														 value: self,
														 comment: "")
	}
	
}
