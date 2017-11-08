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
import Moya

final class ServersListModule: ServersListModuleProtocol {
	
	private let provider: MoyaProvider<TSLServersListTarget> = {
		MoyaProvider(plugins: [TSLServerMessageExtractor(), TSLUserSessionManager.shared])
	}()
	
	final func getServersList(completionHandler: @escaping (Alamofire.Result<Void>) -> Void) {
		
		let handler: (Alamofire.Result<Void>) -> Void = { (result) in
			DispatchQueue.main.async {
				completionHandler(result)
			}
		}
		
		provider.request(.getServersList) { (result) in
			
			guard let value = result.value
				else {
					handler(.failure(result.error!)) // swiftlint:disable:this force_unwrapping
					return
			}
			
			let serversListJSON: [[AnyHashable : Any]]
			do {
				let serversJSON: Any = try value.mapJSON()
				guard let _serversListJSON = serversJSON as? [[AnyHashable : Any]]
				else {
					handler(.failure(APIError.cantCastServerResponse(from: type(of: serversJSON),
																													 to: [[AnyHashable : Any]].self)))
					return
				}
				serversListJSON = _serversListJSON
			} catch {
				handler(.failure(error))
				return
			}
			
			NSManagedObjectContext.coreSaving.saveData { (localContext) in
				
				let sersversList: [ServerData] = ServerData.mr_import(from: serversListJSON, in: localContext) as! [ServerData]
				// swiftlint:disable:previous force_cast
				
				let deletionPredicate: NSPredicate = NSPredicate(format: "NOT (SELF IN %@)",
																												 sersversList.map { $0.objectID })
				ServerData.mr_deleteAll(matching: deletionPredicate, in: localContext)
				
			}.then { (savingResult) in
				
				handler(savingResult.map { _ in () })
				
			}
			
		}
		
	}
	
}
