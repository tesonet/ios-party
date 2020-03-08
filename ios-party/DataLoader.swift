//
//  DataLoader.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import Foundation

let apiBase = "http://playground.tesonet.lt/v1/"

protocol DataLoaderDelegate: AnyObject {
  func presentError(_: Error)
  func presentSuccess(_: ServerListResponseData)
}

final class DataLoader {

  static let shared = DataLoader()
  private let api = API()

  /// This object is set IFF there is a loading sequence in progress
  private var interactiveDelegate: DataLoaderDelegate?

  func beginLoginSequence(user: String, pass: String, delegate: DataLoaderDelegate) {

    precondition(!user.isEmpty && !pass.isEmpty)
    precondition(interactiveDelegate == nil)
    interactiveDelegate = delegate

    let storage = CredentialStorage.shared
    storage.attemptingUser = user
    storage.attemptingPass = pass

    api.post(
      path: "tokens",
      object: TokensRequestData(username: user, password: pass),
      success: self.didReceiveLoginResponse,
      fail: self.presentError
    )

  }

  private func didReceiveLoginResponse(data: TokensResponseData) {

    // save accepted credentials and the new token
    let storage = CredentialStorage.shared
    storage.saveAttemptingLoginCredentials()
    storage.saveToken(data.token)

    // continue to next step - load server list
    if let delegate = interactiveDelegate {
      interactiveDelegate = nil
      beginListLoadSequence(allowLoginRetry: false, delegate: delegate)
    }

  }

  func beginListLoadSequence(allowLoginRetry: Bool = true, delegate: DataLoaderDelegate) {

    precondition(interactiveDelegate == nil)
    interactiveDelegate = delegate

    api.get(
      path: "servers",
      success: self.didReceiveListResponse,
      fail: allowLoginRetry ? self.didReceiveListError : self.presentError
    )

  }

  func didReceiveListResponse(data: ServerListResponseData) {
    if let delegate = interactiveDelegate {
      interactiveDelegate = nil
      delegate.presentSuccess(data)
    }
  }

  func didReceiveListError(error: Error) {

    // if token is unauthorized (401), get a new one with known login credentials
    if let httpError = error as? HTTPError, httpError.code == 401 {

      let storage = CredentialStorage.shared

      if let delegate = interactiveDelegate {
        interactiveDelegate = nil
        beginLoginSequence(
          user: storage.username,
          pass: storage.password,
          delegate: delegate
        )
      }

    } else {

      presentError(error: error)

    }

  }

  private func presentError(error: Error) {
    if let delegate = interactiveDelegate {
      interactiveDelegate = nil
      delegate.presentError(error)
    }
  }

}

struct TokensRequestData: Encodable {
  let username: String
  let password: String
}

struct TokensResponseData: Decodable {
  let token: String
}

typealias ServerListResponseData = Array<ServerListResponseItem>

struct ServerListResponseItem: Decodable {
  let name: String
  let distance: Double
}
