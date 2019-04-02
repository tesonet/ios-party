// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UIFont {
    private enum PrimaryFontName {
        static let light = "Roboto-Light"
        static let bold = "Roboto-Bold"
    }

    // swiftlint:disable force_unwrapping
    static let header = UIFont(name: PrimaryFontName.light, size: 9)!
    static let body = UIFont(name: PrimaryFontName.light, size: 11)!
    static let status = UIFont(name: PrimaryFontName.light, size: 12)!
    static let inputText = UIFont(name: PrimaryFontName.light, size: 10)!
    static let buttonTitle = UIFont(name: PrimaryFontName.bold, size: 10)!

    enum Cell {
        static let title = UIFont(name: PrimaryFontName.light, size: 11)!
        static let value = UIFont(name: PrimaryFontName.light, size: 11)!
    }
    // swiftlint:enable force_unwrapping
}
