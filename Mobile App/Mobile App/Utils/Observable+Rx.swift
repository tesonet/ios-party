//
//  Observable+Rx.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Optionals
// Credit to: https://github.com/RxSwiftCommunity/RxOptional

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

extension ObservableType where E: OptionalType {
    /**
     Unwrap and filter out nil values.
     - returns: Observbale of only successfully unwrapped values.
     */
    func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
}
