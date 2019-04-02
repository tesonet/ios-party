// Created by Paulius Cesekas on 02/04/2019.

import UIKit

protocol TypeName: AnyObject {
    static var typeName: String { get }
}

// Swift Objects
extension TypeName {
    static var typeName: String {
        let type = String(describing: self)
        return type
    }
}

// Bridge to Obj-C
extension NSObject: TypeName {
    class var typeName: String {
        let type = String(describing: self)
        return type
    }
}
