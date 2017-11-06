//
//  ServersListModule.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord
import Alamofire

final class ServersListModule {
	
	private let provider: TSLProvider<TSLServersListTarget> = TSLProvider<TSLServersListTarget>()
	
	final func getServersList(completionHandler: @escaping (Alamofire.Result<Void>) -> Void) {
		
		provider.request(.getServersList) { (result) in
			
			guard let value = result.value
				else {
					completionHandler(.failure(result.error!)) // swiftlint:disable:this force_unwrapping
					return
			}
			
			let serversListJSON: [[AnyHashable : Any]]
			do {
				let serversJSON: Any = try value.mapJSON()
				guard let _serversListJSON = serversJSON as? [[AnyHashable : Any]]
				else {
					completionHandler(.failure(Error.cantCastServerResponse(from: type(of: serversJSON),
																																	to: [[AnyHashable : Any]].self)))
					return
				}
				serversListJSON = _serversListJSON
			} catch {
				completionHandler(.failure(error))
				return
			}
			
			NSManagedObjectContext.coreSaving.saveData { (localContext) in
				
				let sersversList: [ServerData] = ServerData.mr_import(from: serversListJSON, in: localContext) as! [ServerData]
				// swiftlint:disable:previous force_cast
				
				let deletionPredicate: NSPredicate = NSPredicate(format: "NOT (SELF IN %@)",
																												 sersversList.map { $0.objectID })
				ServerData.mr_deleteAll(matching: deletionPredicate, in: localContext)
				
			}.then { (savingResult) in
				
				completionHandler(savingResult.map { _ in () })
				
			}
			
		}
		
	}
	
}

private extension ServersListModule {
	
	enum Error: Swift.Error {
		
		case cantCastServerResponse(from: Any.Type, to: Any.Type)
		
	}
	
}

extension ServersListModule.Error: LocalizedError {
	
	private var localizationKey: String {
		switch self {
		case .cantCastServerResponse:
			return "ERROR.CANT CAST SERVER RESPONSE"
		}
	}
	
	private var localizationTable: String {
		return "ServersList"
	}
	
	var errorDescription: String? {
		switch self {
		case let .cantCastServerResponse(from: from, to: to):
			return String(format: localizationKey.appending(".DESCR").localized(using: localizationTable),
										String(describing: from),
										String(describing: to))
		}
	}
	
	var recoverySuggestion: String? {
		return localizationKey.appending(".SUGGEST").localized(using: localizationTable)
	}
	
}
