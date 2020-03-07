//
//  API.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import Foundation

final class API {

  private let base = URL(string: "http://playground.tesonet.lt/v1/")!

  private let session: URLSession = {

    // url session without cookies and cache
    let config = URLSessionConfiguration.ephemeral
    config.httpCookieAcceptPolicy = .never
    config.httpCookieStorage = nil
    config.httpShouldSetCookies = false
    config.urlCache = nil
    config.urlCredentialStorage = nil

    // all callbacks on the main queue
    return URLSession(configuration: config, delegate: nil, delegateQueue: .main)

  }()

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  /// Creates a request with disabled cache, Authorization header if token is available,
  /// and also sets the Accept header.
  private func createBaseRequest(path: String) -> URLRequest {

    var request = URLRequest(
      url: URL(string: path, relativeTo: base)!,
      cachePolicy: .reloadIgnoringLocalCacheData
    )

    let token = CredentialStorage.shared.token

    if !token.isEmpty {
      request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    }

    request.setValue("application/json", forHTTPHeaderField: "Accept")
    return request

  }

  func get<ResponseObject: Decodable>(
    path: String,
    success: @escaping (ResponseObject) -> Void,
    fail: @escaping (Error) -> Void
  ) {

    let request = createBaseRequest(path: path)
    send(request, success, fail)

  }

  func post<RequestObject: Encodable, ResponseObject: Decodable>(
    path: String,
    object: RequestObject,
    success: @escaping (ResponseObject) -> Void,
    fail: @escaping (Error) -> Void
  ) {

    var request = createBaseRequest(path: path)
    request.httpMethod = "POST"
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! encoder.encode(object)
    send(request, success, fail)

  }

  private func send<ResponseObject: Decodable>(
    _ request: URLRequest,
    _ success: @escaping (ResponseObject) -> Void,
    _ fail: @escaping (Error) -> Void
  ) {

    let task = session.dataTask(with: request) { (_data, _response, _error) in

      if let data = _data, let response = _response as? HTTPURLResponse, _error == nil {

        let code = response.statusCode

        if code == 200 {

          do {
            // successful decode
            let result = try self.decoder.decode(ResponseObject.self, from: data)
            success(result)
          } catch {
            // invalid data format
            fail(error)
          }

        } else {

          do {
            // message from server for non-200 status
            let result = try self.decoder.decode(MessageResponseData.self, from: data)
            fail(HTTPError(code: code, message: result.message))
          } catch {
            // default message for non-200 status
            let mesasge = HTTPURLResponse.localizedString(forStatusCode: code)
            fail(HTTPError(code: code, message: mesasge))
          }

        }

      } else if let error = _error {

        // network error
        fail(error)

      } else {

        // unexpected arguments received
        let blank = NSError(domain: "app", code: -1, userInfo: ["Description": "Unknown"])
        fail(blank)

      }

    }

    task.resume()

  }

}

struct HTTPError: Error {
  let code: Int
  let message: String
}

struct MessageResponseData: Decodable {
  let message: String
}
