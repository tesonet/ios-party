//
//  GenericTools.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

/// i.e. 2018-02-06 12:50:54.689325+0200 AppName[12304:4377007] [AppDelegate.application(_:didFinishLaunchingWithOptions:) 17 <M>]: Example log
func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        let fileName = file.components(separatedBy: "/").last ?? file
        NSLog("[\((fileName as NSString).deletingPathExtension).\(function) \(line) <\((Thread.isMainThread) ? "M" : "B")>]: \(message)")
    #endif
}

func className(fromClass aClass: AnyClass) -> String {
    return String(describing: aClass)
}
