//
//  ColorView.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/17/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

class ColorView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.height * 0.05
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.white.cgColor
    }
    
    func shiftTo(_ red: Float, _ green: Float, _ blue: Float) {
        let r = CGFloat(red)
        let g = CGFloat(green)
        let b = CGFloat(blue)
        backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
}
