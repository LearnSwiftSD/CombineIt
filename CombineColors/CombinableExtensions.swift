//
//  CombinableExtensions.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/18/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit
import Combine

extension Assignment where Base: ColorView {
        
    func color(_ value: Color.Values) {
        baseInstance.shiftTo(value)
    }
    
    func isHidden(_ value: Bool) {
        baseInstance.isHidden = value
    }
    
}

public extension Assignment where Base: UILabel {
    
    func text(_ value: String) {
        baseInstance.text = value
    }
    
}

public extension Assignment where Base: UITextField {
    
    func textColor(_ value: UIColor) {
        baseInstance.textColor = value
    }
    
}
