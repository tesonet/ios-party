// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import RxSwift

public protocol PlaygroundUseCase {
    func servers(with login: Login) -> Observable<[Server]>
}
