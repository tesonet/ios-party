// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UITextField {
    var textOrEmpty: String {
        guard let text = text else {
            return ""
        }
        
        return text
    }
}
