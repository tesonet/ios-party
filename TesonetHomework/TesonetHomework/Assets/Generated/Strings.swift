// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Common {
    internal enum Button {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "Common.Button.cancel")
      /// Ok
      internal static let ok = L10n.tr("Localizable", "Common.Button.ok")
    }
    internal enum Error {
      /// Error
      internal static let title = L10n.tr("Localizable", "Common.Error.title")
    }
  }

  internal enum Login {
    /// 
    internal static let loading = L10n.tr("Localizable", "Login.loading")
    internal enum Button {
      /// Log In
      internal static let login = L10n.tr("Localizable", "Login.Button.login")
    }
    internal enum Error {
      /// Password is required
      internal static let emptyPassword = L10n.tr("Localizable", "Login.Error.emptyPassword")
      /// Username is required
      internal static let emptyUsername = L10n.tr("Localizable", "Login.Error.emptyUsername")
      /// Something went wrong. Please try again.
      internal static let unacceptableResponse = L10n.tr("Localizable", "Login.Error.unacceptableResponse")
      /// Wrong credentials
      internal static let unauthorized = L10n.tr("Localizable", "Login.Error.unauthorized")
    }
    internal enum Placeholder {
      /// Password
      internal static let password = L10n.tr("Localizable", "Login.Placeholder.password")
      /// Username
      internal static let username = L10n.tr("Localizable", "Login.Placeholder.username")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
