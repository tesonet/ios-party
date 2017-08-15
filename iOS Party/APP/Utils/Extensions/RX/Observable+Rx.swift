//
//  Observable+Rx.swift
//

import Foundation
import RxSwift
import RxCocoa
import Moya

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

public extension ObservableType where E: OptionalType {
    /**
     Unwrap and filter out nil values.
     - returns: Observbale of only successfully unwrapped values.
     */
    public func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
    
    /**
     Unwraps optional and replace nil values with value.
     - parameter valueOnNil: Value to emit when nil is found.
     - returns: Observable of unwrapped value or nilValue.
     */
    public func replaceNilWith(valueOnNil: E.Wrapped) -> Observable<E.Wrapped> {
        return self.map { element -> E.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }
    
    /**
     Filter out non nil values.
     - returns: Observbale of only nil values.
     */
    //    public func filterNonNil() -> Observable<Void> {
    //        return filter{ $0 == nil }.mapToVoid()
    //    }
}

// MARK: Void

public extension ObservableType {
    
    /**
     Maps to void observable.
     - returns: Observable of voids
     */
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

// MARK: Subscribe Finished

public extension ObservableType {
    
    /**
     Subscribes a termination handler to an observable sequence.
     
     - parameter onDisposed: Action to invoke upon gracefull or errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func subscribeFinished(onFinished: @escaping () -> Void) -> Disposable {
        return subscribe { event in
            switch event {
            case .error, .completed: onFinished()
            default: break
            }
        }
    }
}

// MARK: Subscribe Weakly

public extension ObservableType {
    
    /**
     Weakly subscribes an element handler to an observable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func subscribeNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> (Self.E) -> Void) -> Disposable {
        return subscribe(onNext: Weakly(object, onNext))
    }
    
    /**
     Weakly subscribes an element handler to an observable sequence and adds it's subscription object to `object.rx_disposeBag`.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the observable sequence.
     */
    public func subscribeNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.E) -> Void) {
        return subscribeNextWeakly(object, onNext).addDisposableTo(object.rx_disposeBag)
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    /**
     Weakly drives an element handler to an drivable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the drivable sequence.
     - returns: Subscription object used to unsubscribe from the drivable sequence.
     */
    public func driveNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> (Self.E) -> Void) -> Disposable {
        return drive(onNext: Weakly(object, onNext))
    }
    
    /**
     Weakly invokes an action for each Next event in the drivable sequence, and propagates all driver messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the drivable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    public func driveNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.E) -> Void) {
        return driveNextWeakly(object, onNext).addDisposableTo(object.rx_disposeBag)
    }
}

// MARK: Weakly
//  Credit to: http://blog.xebia.com/function-references-in-swift-and-retain-cycles/

func Weakly<T: AnyObject, U, V>(_ object: T, _ method: @escaping (T) -> ((U) -> V)) -> ((U) -> V) {
    return { [weak object] parameter in
        if object == nil {
            print("Woop")
        }
        return method(object!)(parameter)
    }
}
