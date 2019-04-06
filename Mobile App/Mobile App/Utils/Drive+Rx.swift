//
//  Drive+Rx.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: Optionals
// Credit to: https://github.com/RxSwiftCommunity/RxOptional

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Driver` of source `Driver`'s elements, with `nil` elements filtered out.
     */
    
    func filterNil() -> Driver<E.Wrapped> {
        return self.flatMap { element -> Driver<E.Wrapped> in
            guard let value = element.value else {
                return Driver<E.Wrapped>.empty()
            }
            return Driver<E.Wrapped>.just(value)
        }
    }
}

