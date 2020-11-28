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
            guard let self = self else { return }

            switch response.result {
            case .success(let data):
                self.didFinishLoginOperation(responseData: data)

            case .failure(let error):
                self.didFailLoginOperation(error: error)
            }
        }
    }
    
    // MARK: - Helpers
    private func didFinishLoginOperation(responseData: Any) {
        guard let responseData = responseData as? [String: Any],
              let token = responseData["token"] as? String else {
            self.delegate?.didFailLoginOperation(dataModel: self)
            return
        }

        authorizationRepository.set(token: token)
        self.delegate?.didFinishLoginOperation(dataModel: self)
    }
    
    private func didFailLoginOperation(error: AFError) {
        print("Login operation failed with error: \(error)")
        self.delegate?.didFailLoginOperation(dataModel: self)
    }
}
