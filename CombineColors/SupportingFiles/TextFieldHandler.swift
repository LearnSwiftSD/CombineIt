//
//  TextFieldHandler.swift
//  CombineColors
//
//  Created by Stephen Martinez on 8/24/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

class TextFieldHandler: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
