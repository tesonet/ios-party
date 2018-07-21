// stackoverflow.com/questions/26913799/remove-println-for-release-version-ios-swift

import UIKit

extension UIViewController {

func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    //print(items: "lplplpppppppp")
    #if DEBUG
    
    var idx = items.startIndex
    let endIdx = items.endIndex
    
    repeat {
        Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
        idx += 1
    }
        while idx < endIdx
    
    #endif
}

}
