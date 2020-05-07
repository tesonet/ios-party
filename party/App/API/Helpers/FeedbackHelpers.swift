//
//  FeedbackHelpers.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func asSignalOrEmpty() -> Signal<Self.Element> {
        return self.asSignal(onErrorSignalWith: .empty())
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
/**
 Unwraps and filters out `nil` elements.
 - returns: `Driver` of source `Driver`'s elements, with `nil` elements filtered out.
 */

    func filterNil() -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return Driver<Element.Wrapped>.empty()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
}
