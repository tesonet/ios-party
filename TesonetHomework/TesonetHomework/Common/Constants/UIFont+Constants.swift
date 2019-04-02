// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UIFont {
    private enum DefaultFontName {
        static let light = "KohinoorTelugu-Light"
        static let regular = "KohinoorTelugu-Regular"
        static let medium = "KohinoorTelugu-Medium"
    }

    // swiftlint:disable force_unwrapping
    static let header = UIFont(name: UIFont.DefaultFontName.medium, size: 32)!
    static let body = UIFont(name: UIFont.DefaultFontName.regular, size: 14)!
    static let caption = UIFont(name: UIFont.DefaultFontName.light, size: 12)!
    static let button = UIFont(name: UIFont.DefaultFontName.light, size: 16)!
    static let input = UIFont(name: UIFont.DefaultFontName.light, size: 14)!
}
