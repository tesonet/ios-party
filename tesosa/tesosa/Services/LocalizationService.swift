import Foundation

struct LocalizationService {
    static func localized(key: String) -> String {
        switch key {
            case "confirmation_button_title":
                return "OK"
            case "unauhorized_error_message":
                return "Unauthorized"
            case "general_error_message":
                return "Something went wrong :{"
            default: 
                assertionFailure("Using untranslated string")
                return "__UNTRANSLATED__"
        }
    }
}
