//
//  ServerPresenterViewModel.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxOptional

enum ServerSortType: String {
    
    case distance = "SORT_DISTANCE"
    case alphanumerical = "SORT_ALPHANUMERICAL"

}

extension ServerSortType: CustomStringConvertible {
    
    var description: String {
        return NSLocalizedString(rawValue, comment: "")
    }
    
}

extension ServerSortType {
    
    static func from(translationString string: String) -> ServerSortType? {
        if string == NSLocalizedString(ServerSortType.distance.rawValue, comment: "") {
            return .distance
        }
    
        if string == NSLocalizedString(ServerSortType.alphanumerical.rawValue, comment: "") {
            return .alphanumerical
        }
        
        return nil
    }
    
}

protocol ServerResultsConsuming {
    
    var servers: AnyObserver<[TestioServer]> { get }
    
}

protocol ServerResultsPresenting {
    
    var serverResults: Driver<[TestioServer]> { get }
    var sortSelection: Action<Void, String> { get }
    
}

protocol LogoutPerforming {
    
    var logout: CocoaAction { get }
    
}

class ServerPresenterViewModel: ServerResultsConsuming, ServerResultsPresenting, LogoutPerforming {

    private let disposeBag = DisposeBag()

    var logout: CocoaAction
    
    var servers: AnyObserver<[TestioServer]> {
        return serversSubject.asObserver()
    }
    
    var serverResults: Driver<[TestioServer]> {
        return serversSubject.asDriver(onErrorJustReturn: [])
    }
    
    private let serversSubject = BehaviorSubject<[TestioServer]>(value: [])

    lazy var sortSelection: Action<Void, String> = {
        return Action<Void, String>(workFactory: { [unowned self] _ in
            let cancelTitle = NSLocalizedString("ALERT_CANCEL", comment: "")
            let sortActions = [ServerSortType.distance.description, ServerSortType.alphanumerical.description]
            
            return self.promptCoordinator.promptFor(title: nil,
                                                    message: nil,
                                                    cancelAction: cancelTitle,
                                                    actions: sortActions,
                                                    style: .actionSheet).take(1)
        })
    }()
    
    private var promptCoordinator: PromptCoordinatingType
    
    init(promptCoordinator: PromptCoordinatingType,
         logout: CocoaAction) {
        self.logout = logout
        self.promptCoordinator = promptCoordinator
        
        sortSelection.elements
            .map { ServerSortType.from(translationString: $0) }
            .filterNil()
            .flatMap { [unowned self] servers in
                self.sortServers(byType: servers)
            }
            .bind(to: serversSubject)
            .disposed(by: disposeBag)
    }
    
    private func sortServers(byType type: ServerSortType) -> Observable<[TestioServer]> {
        return Observable<[TestioServer]>.create { [unowned self] observer -> Disposable in
            do {
                let value = try self.serversSubject.value()
                switch type {
                case .alphanumerical:
                    observer.onNext(value.sorted { $0.name > $1.name })
                case .distance:
                    observer.onNext(value.sorted { $0.distance > $1.distance })
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}
