// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UIColor {
    static let primary = #colorLiteral(red: 0.6235294118, green: 0.8352941176, blue: 0.2, alpha: 1) // #9fd533
    static let secondary = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // #ffffff
    static let tertiary = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) // #666666
    static let tertiaryLighter = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) // #999999
    static let tertiaryLight = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1) // #b2b2b2

    static let header = UIColor.tertiaryLighter
    static let body = UIColor.tertiary
    static let status = UIColor.secondary
    
    enum Button {
        static let foreground = UIColor.secondary
        static let background = UIColor.primary
    }
    enum Input {
        static let foreground = UIColor.tertiaryLight
        static let background = UIColor.secondary
    }
    enum Cell {
        static let title = UIColor.tertiary
        static let value = UIColor.tertiary
        static let separator = UIColor.tertiary
    }
}
