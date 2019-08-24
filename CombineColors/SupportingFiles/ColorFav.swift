//
//  ColorFav.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/17/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

struct FavColor {
    
    var red: Float = 0
    var green: Float = 0
    var blue: Float = 0
    var name: String?
    var colorID = UUID().uuidString
    var timeStamp = Date().timeIntervalSinceReferenceDate
    
    var hex: String {
        let my = ColorHelper.toDecimalRGB(r: red, g: green, b: blue)
        return ColorHelper.toHexRGB(r: my.red, g: my.green, b: my.blue)
    }
    
    init(r: Float, g: Float, b: Float, name: String? = nil) {
        self.red = r
        self.green = g
        self.blue = b
        self.name = name
    }
    
}
