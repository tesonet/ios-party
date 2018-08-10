//
//  Token.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/26/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation

struct Token: Codable {
    
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    func encode() {
        do {
            let data = try PropertyListEncoder().encode([self])
            NSKeyedArchiver.archiveRootObject(data, toFile: Token.Helper.path())
        } catch {
            debugPrint("Encoding failed with error: \(error.localizedDescription)")
        }
    }
    
    static func decode() -> Token? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: Token.Helper.path()) as? Data else {
            return nil
        }
        do {
            return try PropertyListDecoder().decode([Token].self, from: data).first
        } catch {
            print("Token retrieval has failed with error: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Token {
    class Helper: NSObject {
        class func path() -> String {
            let tokenPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true).first
            let path = tokenPath?.appending("/\(TesioHelper.Constant.tokenKey)")
            debugPrint("Token path: \(String(describing: path!))")
            return path!
        }
    }
}
