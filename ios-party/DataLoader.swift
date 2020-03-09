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
  func presentSuccess()
}

private struct LoadingSequenceDescriptor {
  let delegate: DataLoaderDelegate
  var dataTask: URLSessionDataTask
}

final class DataLoader {

  static let shared = DataLoader()
  private let api = API()

  private var currentSequence: LoadingSequenceDescriptor?

  var isLoading: Bool {
    return currentSequence != nil
  }

  func beginLoginSequence(user: String, pass: String, delegate: DataLoaderDelegate) {

    precondition(!user.isEmpty && !pass.isEmpty)
    precondition(currentSequence == nil)

    let storage = CredentialStorage.shared
    storage.attemptingUser = user
    storage.attemptingPass = pass

    let dataTask = api.post(
      path: "tokens",
      object: TokensRequestData(username: user, password: pass),
      context: delegate,
      success: self.didReceiveLoginResponse,
      fail: self.presentError
    )

    currentSequence = LoadingSequenceDescriptor(delegate: delegate, dataTask: dataTask)

  }

  private func didReceiveLoginResponse(data: TokensResponseData, context: DataLoaderDelegate) {

    guard let descriptor = currentSequence, descriptor.delegate === context else { return }

    // save accepted credentials and the new token
    let storage = CredentialStorage.shared
    storage.saveAttemptingLoginCredentials()
    storage.saveToken(data.token)

    // continue to next step - load server list
    if let descriptor = currentSequence {
      currentSequence = nil
      beginListLoadSequence(allowLoginRetry: false, delegate: descriptor.delegate)
    }

  }

  func beginListLoadSequence(allowLoginRetry: Bool = true, delegate: DataLoaderDelegate) {

    precondition(currentSequence == nil)

    if CredentialStorage.shared.token.isEmpty {
      delegate.presentError(ApplicationDataError.missingToken)
      return
    }

    let dataTask = api.get(
      path: "servers",
      context: delegate,
      success: self.didReceiveListResponse,
      fail: allowLoginRetry ? self.didReceiveListError : self.presentError
    )

    currentSequence = LoadingSequenceDescriptor(delegate: delegate, dataTask: dataTask)

  }

  func didReceiveListResponse(data: Array<ServerDescriptor>, context: DataLoaderDelegate) {

    guard let descriptor = currentSequence, descriptor.delegate === context else { return }

    ServerStorage.shared.updateList(data)

    if let descriptor = currentSequence {
      currentSequence = nil
      descriptor.delegate.presentSuccess()
    }
  }

  func didReceiveListError(error: Error, context: DataLoaderDelegate) {

    guard let descriptor = currentSequence, descriptor.delegate === context else { return }

    // if token is unauthorized (401), get a new one with known login credentials
    if let httpError = error as? HTTPError, httpError.code == 401 {

      let storage = CredentialStorage.shared

      if let descriptor = currentSequence {
        currentSequence = nil
        beginLoginSequence(
          user: storage.username,
          pass: storage.password,
          delegate: descriptor.delegate
        )
      }

    } else {

      presentError(error: error, context: context)

    }

  }

  private func presentError(error: Error, context: DataLoaderDelegate) {

    guard let descriptor = currentSequence, descriptor.delegate === context else { return }

    if let descriptor = currentSequence {
      currentSequence = nil
      descriptor.delegate.presentError(error)
    }

  }

  func cancelAnyTasks() {
    if let descriptor = currentSequence {
      currentSequence = nil
      descriptor.dataTask.cancel()
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

enum ApplicationDataError: Error {
  case missingToken
}
