// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UIColor {
    static let primary = #colorLiteral(red: 0.6235294118, green: 0.8352941176, blue: 0.2, alpha: 1) // #9fd533
    static let secondary = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // #ffffff
    static let tertiary = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) // #666666
    static let tertiaryLighter = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) // #999999
    static let tertiaryLight = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1) // #b2b2b2
    static let tertiaryExtraLight = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) // #f0f0f0
    static let quaternary = #colorLiteral(red: 0.1843137255, green: 0.1960784314, blue: 0.3294117647, alpha: 1) // #2f3254

    static let header = UIColor.tertiaryLighter
    static let body = UIColor.tertiary
    static let status = UIColor.secondary
    static let shadow = #colorLiteral(red: 0.02745098039, green: 0.1490196078, blue: 0.2196078431, alpha: 0.2) // #072638 0.2

    enum Button {
        static let background = UIColor.primary
        static let foreground = UIColor.secondary
    }
    enum FilterButton {
        static let background = UIColor.quaternary.withAlphaComponent(0.9)
        static let foreground = UIColor.secondary
    }
    enum Input {
        static let background = UIColor.secondary
        static let foreground = UIColor.tertiaryLight
    }
    enum Cell {
        static let title = UIColor.tertiary
        static let value = UIColor.tertiary
        static let separator = UIColor.tertiaryLighter
    }
    enum NavigationBar {
        static let background = UIColor.tertiaryExtraLight
        static let foreground = UIColor.quaternary
    }

}
