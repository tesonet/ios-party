//
//  ServerError.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya

struct ServerError: Decodable {
	
	let message: String
	
	init(message: String) {
		self.message = message
	}
	
	init?(response: Response) {
		
		guard let serverMessage: ServerError = try? JSONDecoder().decode(ServerError.self, from: response.data)
			else {
				return nil
		}
		
		self = serverMessage
		
	}
	
}
