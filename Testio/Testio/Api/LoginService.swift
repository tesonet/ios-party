//
//  LoginService.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import Alamofire

class LoginService {
    func login(with credentials: Credentials, completion: @escaping (LoginResponse) -> Void) {
        Alamofire
            .request(ApiUrlRouter.login(credentials))
            .validate(statusCode: 200..<500)
            .responseJSON { (response) in
                print()
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, let data = response.data {
                        switch statusCode {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let token = try decoder.decode(Token.self, from: data)
                                completion(LoginResponse(token: token))
                            } catch {
                                completion(LoginResponse(error: ServiceError.cantReadJSON))
                            }
                        case 401:
                            do {
                                let decoder = JSONDecoder()
                                let error = try decoder.decode(ErrorMessage.self, from: data)
                                completion(LoginResponse(error: ServiceError.invalidCredentails(text: error.message)))
                            } catch {
                                completion(LoginResponse(error: ServiceError.cantReadJSON))
                            }
                        default:
                            completion(LoginResponse(error: ServiceError.unknownError))
                        }
                    }
                    completion(LoginResponse(error: ServiceError.noData))
                case .failure:
                    completion(LoginResponse(error: ServiceError.unknownError))
                }
        }
    }
}
