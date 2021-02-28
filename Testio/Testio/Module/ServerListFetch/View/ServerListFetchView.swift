//
//  ServerListFetchView.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ServerListFetchView: BaseView {
    var onUnauthorized: (() -> Void)? { get set }
    var onSuccess: (() -> Void)? { get set }
}
