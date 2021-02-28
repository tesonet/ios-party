//
//  SortOptionsBuilder.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

final class SortOptionsBuilder: ServiceFactoryContainer {
    func view() -> SortOptionsView {
        SortOptionsViewController()
    }
}
