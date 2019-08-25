//
//  CombinableExtensions.swift
//  CombineColors
//
//  Created by Stephen Martinez on 8/18/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit
 
// These extensions provide the inputs for `Combinable` types

extension Assignment where Base: ColorView {
        
    func color(_ inputValue: Color.Values) {
        baseInstance.shiftTo(inputValue)
    }
    
    func isHidden(_ inputValue: Bool) {
        baseInstance.isHidden = inputValue
    }
    
}

public extension Assignment where Base: UILabel {
    
    func text(_ inputValue: String) {
        baseInstance.text = inputValue
    }
    
}

public extension Assignment where Base: UITextField {
    
    func textColor(_ inputValue: UIColor) {
        baseInstance.textColor = inputValue
    }
    
}
