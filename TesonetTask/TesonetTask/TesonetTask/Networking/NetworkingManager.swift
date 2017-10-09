//
//  NetworkingManager.swift
//  TesonetTask
//
//  Created by abelenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

enum ServerError : Error {
    case unauthorized
    case unknown
    
    init(string:String) {
        switch string {
            case "Unauthorized":
                self = .unauthorized
            default:
                self = .unknown
        }
    }
    
    func description() -> String {
        switch self {
            case .unauthorized:
                return "You are not authorized"
            default:
                return "Error on loading"
        }
    }
}

class NetworkingManager: NSObject {
    typealias kRequestCompletion = (Data?, URLResponse?, Error?) -> Void
    typealias kLoginCompletion = (UserModel?, Error?) -> Void
    static let kBaseURLString = "http://playground.tesonet.lt/v1/"
    
    internal class func login(userName: String, password: String, completion:@escaping kLoginCompletion) -> URLSessionTask {
        let dataTask = LoginRequest.login(username: userName, password: password)
        {(outData, outResponse, outError) in
            var theError : Error? = outError
            var theUser : UserModel?
            if let JSONDict = JSONDict(from: outData) {
                if let token = JSONDict[Constants.tokenKey] as? String {
                    theUser = UserModel(token:token, username:userName)
                } else {
                    theError = ServerError(string:JSONDict[Constants.messageKey] as? String ?? "")
                }
            }
            completion(theUser, theError)
        }
        return dataTask
    }
    
    private class func JSONDict(from data:Data?) -> [String:Any]? {
        var JSONDict : [String:Any]?
        if let theData = data {
            do {
                JSONDict = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as? [String:Any]
            } catch {
                NSLog("Error on parsing JSON")
            }
        }
        return JSONDict
    }
    
}
