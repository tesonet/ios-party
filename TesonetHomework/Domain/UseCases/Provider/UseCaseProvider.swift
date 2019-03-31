// Created by Paulius Cesekas on 01/04/2019.

import Foundation

public protocol UseCaseProvider {
    func makeAuthorizationUseCase() -> AuthorizationUseCase
    func makePlaygroundUseCase() -> PlaygroundUseCase
}
