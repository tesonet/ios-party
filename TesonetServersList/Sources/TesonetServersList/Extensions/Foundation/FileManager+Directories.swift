//
//  FileManager+Directories.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

extension FileManager {
	
	/// Returns application support directory in user domain mask.
	final var applicationSupportDirectory: URL {
		
		let urls = self.urls(for: .applicationSupportDirectory, in: .userDomainMask)
		
		return urls[urls.endIndex - 1]
		
	}
	
}
