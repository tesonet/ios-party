//
//  APIClient.swift
//  Servers
//
//  Created by Rimantas Lukosevicius on 10/06/2018.
//  Copyright © 2018 Rimantas Lukosevicius. All rights reserved.
//

import UIKit
import CoreData

struct TokenRequest : Encodable {
    var username : String;
    var password : String;
}

struct ServerFromAPI : Decodable {
    var name : String
    var distance : Double
}

class APIClient: NSObject {
    private var token : String?
    
    static let shared : APIClient = APIClient()
    
    func obtainTokenWith(username:String, password:String, completion: @escaping (_ success: Bool) -> Void) {
        let request = TokenRequest(username: username, password: password)
        
        let jsonEncoder = JSONEncoder()
        let requestJSON = try! jsonEncoder.encode(request)
        
        var httpRequest = URLRequest.init(url: URL(string: "http://playground.tesonet.lt/v1/tokens")!)
        httpRequest.httpMethod = "POST"
        httpRequest.httpBody = requestJSON
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =
        URLSession.shared.dataTask(with: httpRequest) { (respData, resp, err) in
            guard err == nil else {
                print("Error from data task: \(String(describing: err))")
                completion(false)
                return
            }
            
            guard resp != nil else {
                print("Error: no response from /v1/tokens/")
                completion(false)
                return
            }
            
            guard respData != nil else {
                print("Error: no payload from /v1/tokens/")
                completion(false)
                return
            }
            
            if let respData = respData {
                guard let respDict = try? JSONSerialization.jsonObject(with: respData, options: []) as? Dictionary<String, String> else {
                    print("Error: JSON parsing failed")
                    completion(false)
                    return
                }
                
                guard let token = respDict?["token"] else {
                    print("Error: cannot find .token in JSON response")
                    completion(false)
                    return
                }
                
                self.token = token
                completion(true)
            }
        }
        
        task.resume()
    }
    
    private func saveServerFromAPItoDB(_ serversFromAPI : [ServerFromAPI],
                                       completion: @escaping (_ success: Bool) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Server")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        guard ((try? context.execute(request)) != nil) else {
            print("Error: failed to delete old data")
            completion(false)
            return
        }
        
        for s in serversFromAPI {
            let entity = NSEntityDescription.entity(forEntityName: "Server", in: context)
            let serverInDB = NSManagedObject(entity: entity!, insertInto: context) as? Server
            
            serverInDB?.name = s.name
            serverInDB?.distance = s.distance
        }
        
        do {
            try context.save()
        } catch {
            print("Error: failed to save to CoreData")
            completion(false)
            return
        }
        
        completion(true)
    }
    
    func downloadAndSaveData(completion: @escaping (_ success: Bool) -> Void) {
        guard let token = self.token else {
            print("Error: failed to get token")
            completion(false)
            return
        }
        
        let tokenHeader = "Bearer " + token
        
        var httpRequest = URLRequest(url: URL(string: "http://playground.tesonet.lt/v1/servers")!)
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.setValue(tokenHeader, forHTTPHeaderField: "Authorization")
        
        let task =
        URLSession.shared.dataTask(with: httpRequest) { (respData, resp, err) in
            guard err == nil else {
                print("Error from data task: \(String(describing: err))")
                completion(false)
                return
            }
            
            guard resp != nil else {
                print("Error: no response from /v1/servers/")
                completion(false)
                return
            }
            
            guard let respData = respData else {
                print("Error: no payload from /v1/servers/")
                completion(false)
                return
            }
            
            let respString = String(data: respData, encoding: .utf8)!
            print(respString)
            
            let decoder = JSONDecoder()
            
            guard let serversFromAPI = try? decoder.decode([ServerFromAPI].self, from: respData) else {
                print("Error: JSON decoding failed")
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                self.saveServerFromAPItoDB(serversFromAPI, completion: completion)
            }
        }

        task.resume()
    }
    
}
