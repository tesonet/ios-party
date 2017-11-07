//
//  String+Normalized.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

extension String {
	
	/// Returns diacritic & case normalized string.
	///
	/// - Returns: Diacritic & case normalized string.
	func normalized() -> String {
		return self.folding(options: [.diacriticInsensitive,
																	.caseInsensitive],
												locale: .none)
	}
	
}
