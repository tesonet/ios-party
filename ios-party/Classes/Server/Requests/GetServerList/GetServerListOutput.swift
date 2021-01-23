//
//  GetServerListOutput.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import Alamofire

class GetServerListOutput {
    
    // MARK: - Declarations
    var isSuccessful: Bool = false
    var serverList: [ServerEntity] = []
    var error: AFError?
}
