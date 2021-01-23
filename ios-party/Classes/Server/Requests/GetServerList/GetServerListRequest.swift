//
//  GetServerListRequest.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import Alamofire

class GetServerListRequest {
    
    // MARK: - Constants
    private let kGetServerListRequestURLString = "https://playground.tesonet.lt/v1/servers"
    
    // MARK: - Declarations
    private (set) var input: GetServerListInput
    private (set) var output = GetServerListOutput()
    var completionHandler: (() -> Void)?
    
    // MARK: - Methods
    init(withInput input: GetServerListInput) {
        self.input = input
    }
    
    func start() {
        let request: DataRequest = AF.request(kGetServerListRequestURLString,
                                              method: .get,
                                              headers: [.authorization(bearerToken: input.token)])
            .validate(statusCode: 200..<300)
        
        request.responseJSON(completionHandler: { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.didFinishGetServerListRequest(responseData: data)
                
            case .failure(let error):
                self?.didFailGetServerListRequest(error: error)
            }
        })
    }
    
    private func didFinishGetServerListRequest(responseData: Any) {
        guard let responseDictList = responseData as? [[String: Any]] else {
            log("ERROR! Could not parse response dictionary from response data: \(responseData)")
            completionHandler?()
            return
        }
        
        log("\(responseDictList)")
        output.isSuccessful = true
        
        completionHandler?()
    }
    
    private func didFailGetServerListRequest(error: AFError) {
        output.error = error
        
        completionHandler?()
    }
}
