//
//  LoginDataModel.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import Alamofire
import Foundation

class LoginDataModel {
    
    // MARK: - Declarations
    private var delegate: LoginDataModelDelegate?
    
    // MARK: - Dependencies
    private let operation = LoginOperation()
    private let authorizationRepository = AuthorizationRepository.shared
    
    // MARK: - Methods
    init(delegate: LoginDataModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public
    func login(withUsername username: String, password: String) {
        delegate?.didStartLoginOperation(dataModel: self)

        let request: DataRequest = operation.request(with: username, password: password)
        request.responseJSON { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.didFinishLoginOperation(responseData: data)

            case .failure(let error):
                // 1. one of option how to handle 401
                guard response.response?.statusCode == 401 else {
                    self?.didFailLoginOperation(error: error)
                    return
                }
                
                // Handle 401
                self?.didFailLoginOperation(error: error)
                
                // We also could in LoginOperation.request remove validation of 200..<300
                // in that case if we get something from server, response is valid and response.result = .success(_)
                // Do validation on ourselves:
                // * check for valid ex: 200..<300,
                // * check for special ones ex: 401 ... etc
            }
        }
    }
    
    // MARK: - Helpers
    private func didFinishLoginOperation(responseData: Any) {
        guard let token = operation.parseAccessToken(response: responseData) else {
            delegate?.didFailLoginOperation(dataModel: self, message: "Something wrong happened!")
            print("could not parse token!")
            return
        }
        
        authorizationRepository.set(token: token)
        delegate?.didFinishLoginOperation(dataModel: self)
    }
    
    private func didFailLoginOperation(error: AFError) {
        print("login operation failed with error: \(error)")
        delegate?.didFailLoginOperation(dataModel: self, message: error.localizedDescription)
    }
}
