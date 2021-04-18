//
//  Busy.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 18/04/2021.
//

import SwiftUI

struct BusyKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var busy: Bool {
        get { self[BusyKey.self] }
        set { self[BusyKey.self] = newValue }
    }
}

extension View {
    func busy(_ isBusy: Bool) -> some View {
        environment(\.busy, isBusy)
    }
}
