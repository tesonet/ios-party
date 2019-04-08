// Created by Paulius Cesekas on 07/04/2019.

import Foundation

class Utility {
    class func classNameAsString<T>(_ object: T) -> String {
        return String(describing: type(of: object)).components(separatedBy: ".").first ?? ""
    }
}
