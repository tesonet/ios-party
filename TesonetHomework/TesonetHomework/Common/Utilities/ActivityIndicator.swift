// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
    // swiftlint:disable type_name
    public typealias E = Bool
    // swiftlint:enable type_name
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let recursiveLock = NSRecursiveLock()
    private var variable = PublishSubject<E>()
    private let loading: SharedSequence<SharingStrategy, E>
    
    public init() {
        loading = variable.asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        recursiveLock.lock()
        variable.onNext(true)
        recursiveLock.unlock()
    }
    
    private func sendStopLoading() {
        recursiveLock.lock()
        variable.onNext(false)
        recursiveLock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
