//
//  ColorHelper.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/17/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

struct ColorHelper {
    
    static func toHexRGB(r: Int, g: Int, b: Int) -> String{
        let hexR = (hexConvert(r) ?? "<r: value out of bounds>")
        let hexG = (hexConvert(g) ?? "<g: value out of bounds>")
        let hexB = (hexConvert(b) ?? "<b: value out of bounds>")
        return hexR + hexG + hexB
    }
    
    static func toDecimal(r: Float, g: Float, b: Float) -> (red: Int, green: Int, blue: Int) {
        let decimalR = Int(r * 255)
        let decimalG = Int(g * 255)
        let decimalB = Int(b * 255)
        return (decimalR, decimalG, decimalB)
    }
    
    private static func hexConvert(_ num: Int) -> String?{
        if num > 255 { return nil }
        let firstHex = Int(num/16)
        let secondHex = Int(num - (firstHex * 16))
        let hexRef = [
            0:"0",1:"1",2:"2",3:"3",4:"4",5:"5",
            6:"6",7:"7",8:"8",9:"9",10:"A",11:"B",
            12:"C",13:"D",14:"E",15:"F"]
        return hexRef[firstHex]! + hexRef[secondHex]!
    }
    
}
