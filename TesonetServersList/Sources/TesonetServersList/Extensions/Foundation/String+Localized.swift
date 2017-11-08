//
//  String+Localized.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

extension String {
	
	/// Returns the localized string for the receicer’s key in `Localized.strings` of main bundle.
	///
	/// - Returns: The localized string.
	func localized() -> String {
		return self.localized(using: "Localized", in: .main)
	}
	
	/// Returns the localized string.
	///
	/// - Parameters:
	///   - tableName: The receiver’s string table to search.
	///   - bunlde:  The receiver’s bundle to search. Default value: `.main`.
	/// - Returns: The localized string.
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
