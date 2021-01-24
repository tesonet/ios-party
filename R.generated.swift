//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `database.sqlite`.
    static let databaseSqlite = Rswift.FileResource(bundle: R.hostingBundle, name: "database", pathExtension: "sqlite")

    /// `bundle.url(forResource: "database", withExtension: "sqlite")`
    static func databaseSqlite(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.databaseSqlite
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 7 images.
  struct image {
    /// Image `bg`.
    static let bg = Rswift.ImageResource(bundle: R.hostingBundle, name: "bg")
    /// Image `ico-lock`.
    static let icoLock = Rswift.ImageResource(bundle: R.hostingBundle, name: "ico-lock")
    /// Image `ico-logout`.
    static let icoLogout = Rswift.ImageResource(bundle: R.hostingBundle, name: "ico-logout")
    /// Image `ico-sort-light`.
    static let icoSortLight = Rswift.ImageResource(bundle: R.hostingBundle, name: "ico-sort-light")
    /// Image `ico-username`.
    static let icoUsername = Rswift.ImageResource(bundle: R.hostingBundle, name: "ico-username")
    /// Image `logo-dark`.
    static let logoDark = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo-dark")
    /// Image `logo-white`.
    static let logoWhite = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo-white")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "bg", bundle: ..., traitCollection: ...)`
    static func bg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.bg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ico-lock", bundle: ..., traitCollection: ...)`
    static func icoLock(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icoLock, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ico-logout", bundle: ..., traitCollection: ...)`
    static func icoLogout(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icoLogout, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ico-sort-light", bundle: ..., traitCollection: ...)`
    static func icoSortLight(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icoSortLight, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ico-username", bundle: ..., traitCollection: ...)`
    static func icoUsername(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icoUsername, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "logo-dark", bundle: ..., traitCollection: ...)`
    static func logoDark(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logoDark, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "logo-white", bundle: ..., traitCollection: ...)`
    static func logoWhite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logoWhite, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 5 nibs.
  struct nib {
    /// Nib `LoaderViewController`.
    static let loaderViewController = _R.nib._LoaderViewController()
    /// Nib `LoginViewController`.
    static let loginViewController = _R.nib._LoginViewController()
    /// Nib `ServerCell`.
    static let serverCell = _R.nib._ServerCell()
    /// Nib `ServerListHeaderView`.
    static let serverListHeaderView = _R.nib._ServerListHeaderView()
    /// Nib `ServerListViewController`.
    static let serverListViewController = _R.nib._ServerListViewController()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "LoaderViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.loaderViewController) instead")
    static func loaderViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.loaderViewController)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "LoginViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.loginViewController) instead")
    static func loginViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.loginViewController)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "ServerCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.serverCell) instead")
    static func serverCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.serverCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "ServerListHeaderView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.serverListHeaderView) instead")
    static func serverListHeaderView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.serverListHeaderView)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "ServerListViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.serverListViewController) instead")
    static func serverListViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.serverListViewController)
    }
    #endif

    static func loaderViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.loaderViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func loginViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.loginViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func serverCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ServerCell? {
      return R.nib.serverCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ServerCell
    }

    static func serverListHeaderView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ServerListHeaderView? {
      return R.nib.serverListHeaderView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ServerListHeaderView
    }

    static func serverListViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.serverListViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 11 localization keys.
    struct localizable {
      /// en translation: %@ km
      ///
      /// Locales: en
      static let x_km = Rswift.StringResource(key: "x_km", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Alphanumerical
      ///
      /// Locales: en
      static let sort_alphanumerical = Rswift.StringResource(key: "sort_alphanumerical", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Cancel
      ///
      /// Locales: en
      static let cancel_action = Rswift.StringResource(key: "cancel_action", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: DISTANCE
      ///
      /// Locales: en
      static let distance_header = Rswift.StringResource(key: "distance_header", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Distance
      ///
      /// Locales: en
      static let sort_distance = Rswift.StringResource(key: "sort_distance", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Fetching the list...
      ///
      /// Locales: en
      static let loading_message = Rswift.StringResource(key: "loading_message", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Log in
      ///
      /// Locales: en
      static let login_action = Rswift.StringResource(key: "login_action", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Password
      ///
      /// Locales: en
      static let password_placeholder = Rswift.StringResource(key: "password_placeholder", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: SERVER
      ///
      /// Locales: en
      static let server_header = Rswift.StringResource(key: "server_header", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Sort
      ///
      /// Locales: en
      static let sort_action = Rswift.StringResource(key: "sort_action", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Username
      ///
      /// Locales: en
      static let username_placeholder = Rswift.StringResource(key: "username_placeholder", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)

      /// en translation: %@ km
      ///
      /// Locales: en
      static func x_km(_ value1: String, preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          let format = NSLocalizedString("x_km", bundle: hostingBundle, comment: "")
          return String(format: format, locale: applicationLocale, value1)
        }

        guard let (locale, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "x_km"
        }

        let format = NSLocalizedString("x_km", bundle: bundle, comment: "")
        return String(format: format, locale: locale, value1)
      }

      /// en translation: Alphanumerical
      ///
      /// Locales: en
      static func sort_alphanumerical(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("sort_alphanumerical", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "sort_alphanumerical"
        }

        return NSLocalizedString("sort_alphanumerical", bundle: bundle, comment: "")
      }

      /// en translation: Cancel
      ///
      /// Locales: en
      static func cancel_action(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("cancel_action", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "cancel_action"
        }

        return NSLocalizedString("cancel_action", bundle: bundle, comment: "")
      }

      /// en translation: DISTANCE
      ///
      /// Locales: en
      static func distance_header(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("distance_header", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "distance_header"
        }

        return NSLocalizedString("distance_header", bundle: bundle, comment: "")
      }

      /// en translation: Distance
      ///
      /// Locales: en
      static func sort_distance(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("sort_distance", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "sort_distance"
        }

        return NSLocalizedString("sort_distance", bundle: bundle, comment: "")
      }

      /// en translation: Fetching the list...
      ///
      /// Locales: en
      static func loading_message(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("loading_message", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "loading_message"
        }

        return NSLocalizedString("loading_message", bundle: bundle, comment: "")
      }

      /// en translation: Log in
      ///
      /// Locales: en
      static func login_action(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("login_action", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "login_action"
        }

        return NSLocalizedString("login_action", bundle: bundle, comment: "")
      }

      /// en translation: Password
      ///
      /// Locales: en
      static func password_placeholder(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("password_placeholder", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "password_placeholder"
        }

        return NSLocalizedString("password_placeholder", bundle: bundle, comment: "")
      }

      /// en translation: SERVER
      ///
      /// Locales: en
      static func server_header(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("server_header", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "server_header"
        }

        return NSLocalizedString("server_header", bundle: bundle, comment: "")
      }

      /// en translation: Sort
      ///
      /// Locales: en
      static func sort_action(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("sort_action", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "sort_action"
        }

        return NSLocalizedString("sort_action", bundle: bundle, comment: "")
      }

      /// en translation: Username
      ///
      /// Locales: en
      static func username_placeholder(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("username_placeholder", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "username_placeholder"
        }

        return NSLocalizedString("username_placeholder", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try nib.validate()
    #endif
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _LoaderViewController.validate()
      try _LoginViewController.validate()
      try _ServerListViewController.validate()
    }

    struct _LoaderViewController: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "LoaderViewController"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      static func validate() throws {
        if UIKit.UIImage(named: "bg", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'bg' is used in nib 'LoaderViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }

    struct _LoginViewController: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "LoginViewController"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      static func validate() throws {
        if UIKit.UIImage(named: "bg", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'bg' is used in nib 'LoginViewController', but couldn't be loaded.") }
        if UIKit.UIImage(named: "ico-lock", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'ico-lock' is used in nib 'LoginViewController', but couldn't be loaded.") }
        if UIKit.UIImage(named: "ico-username", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'ico-username' is used in nib 'LoginViewController', but couldn't be loaded.") }
        if UIKit.UIImage(named: "logo-white", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'logo-white' is used in nib 'LoginViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }

    struct _ServerCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "ServerCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ServerCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ServerCell
      }

      fileprivate init() {}
    }

    struct _ServerListHeaderView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "ServerListHeaderView"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ServerListHeaderView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ServerListHeaderView
      }

      fileprivate init() {}
    }

    struct _ServerListViewController: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "ServerListViewController"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      static func validate() throws {
        if UIKit.UIImage(named: "ico-logout", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'ico-logout' is used in nib 'ServerListViewController', but couldn't be loaded.") }
        if UIKit.UIImage(named: "ico-sort-light", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'ico-sort-light' is used in nib 'ServerListViewController', but couldn't be loaded.") }
        if UIKit.UIImage(named: "logo-dark", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'logo-dark' is used in nib 'ServerListViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "bg", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'bg' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
