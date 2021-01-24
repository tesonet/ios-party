//
//  LoaderDataModel.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import Alamofire

protocol LoaderDataModelDelegate: AnyObject {
    func loaderDataModel(didFinishLoading dataModel: LoaderDataModelInterface)
    func loaderDataModel(didFailLoading dataModel: LoaderDataModelInterface)
}

protocol LoaderDataModelInterface {
    func startDataLoad()
}

class LoaderDataModel: LoaderDataModelInterface {
    
    // MARK: - Declarations
    weak var delegate: LoaderDataModelDelegate?
    
    var isLoading = false
    
    // MARK: - Dependencies
    var authorization: AuthorizationInterface = Authorization.shared
    var serverListRepository: ServerListRepositoryInterface = ServerListRepository.shared
    var applicationRepository: ApplicationRepositoryInterface = ApplicationRepository()
    
    // MARK: - Methods
    init(delegate: LoaderDataModelDelegate) {
        self.delegate = delegate
    }
    
    func startDataLoad() {
        guard !isLoading else {
            log("ERROR! Loading is already in progress.")
            return
        }
        
        guard let authorizationToken = authorization.token() else {
            log("ERROR! User not logged in")
            return
        }
        
        isLoading = true
        applicationRepository.setDidLoadData(to: false)
        startGetServerListRequest(authorizationToken: authorizationToken)
    }
    
    func startGetServerListRequest(authorizationToken: String) {
        let input = GetServerListInput(token: authorizationToken)
        let request = GetServerListRequest(withInput: input)
        request.completionHandler = { [weak self] in
            self?.didFinishGetServerListRequest(request)
        }
        
        request.start()
    }
    
    func didFinishGetServerListRequest(_ request: GetServerListRequest) {
        isLoading = false
        
        guard request.output.isSuccessful else {
            didFailGetServerListRequest(error: request.output.error)
            return
        }
        
        serverListRepository.setServerList(serverList: request.output.serverList)
        applicationRepository.setDidLoadData(to: true)
        NotificationCenter.default.post(Notification.DidFinishLoading())
        delegate?.loaderDataModel(didFinishLoading: self)
    }
    
    func didFailGetServerListRequest(error: AFError?) {
        guard let error: AFError = error else {
            log("ERROR Loading failed without error.")
            delegate?.loaderDataModel(didFailLoading: self)
            return
        }
        
        if error.responseCode == 401 {
            log("ERROR! Loading failed with code 401")
            delegate?.loaderDataModel(didFailLoading: self)
        } else {
            log("Loading failed with error: \(error)")
            delegate?.loaderDataModel(didFailLoading: self)
        }
    }
}
