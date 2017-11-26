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
        case "sort_by_distance_button_title":
            return "By Distance"
        case "sort_by_name":
            return "Alphanumerical"
        case "cancel_button_title":
            return "Cancel"
        default: 
            assertionFailure("Using untranslated string")
            return "__UNTRANSLATED__"
        }
    }
}
