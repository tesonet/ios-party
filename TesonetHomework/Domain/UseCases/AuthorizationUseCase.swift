// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import RxSwift

public protocol AuthorizationUseCase {
    func login(withUsername username: String, password: String) -> Observable<Login>
}
