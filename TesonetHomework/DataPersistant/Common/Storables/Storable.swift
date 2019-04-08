// Created by Paulius Cesekas on 07/04/2019.

import Foundation

public protocol Storable { }

public protocol ToStorable {
    func toStorable() -> Storable?
}
