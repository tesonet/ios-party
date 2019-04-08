// Created by Paulius Cesekas on 01/04/2019.

import Foundation

public enum NetworkError: Error {
    case unacceptableStatusCode(Int)
    case emptyBody
    case unserializableBody
    case unauthorized
}
