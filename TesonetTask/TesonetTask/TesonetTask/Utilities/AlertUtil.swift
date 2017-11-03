//
//  AlertUtil.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import AppKit

struct AlertUtil {

    @discardableResult
    static func showInformationalAlert(title: String,
                                       text: String,
                                       buttonTitles: [String]) -> NSModalResponse {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = title
        alert.informativeText = text

        for buttonTitle in buttonTitles {
            alert.addButton(withTitle: buttonTitle)
        }

        return alert.runModal()
    }
}
