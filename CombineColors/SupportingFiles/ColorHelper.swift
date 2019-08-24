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
        let hexR = toHex(colorValue: r)
        let hexG = toHex(colorValue: g)
        let hexB = toHex(colorValue: b)
        return hexR + hexG + hexB
    }
    
    static func toHex(colorValue: Int) -> String {
        return (hexConvert(colorValue) ?? "<value out of bounds>")
    }
    
    static func toDecimalRGB(r: Float, g: Float, b: Float) -> (red: Int, green: Int, blue: Int) {
        let decimalR = toDecimal(colorValue: r)
        let decimalG = toDecimal(colorValue: g)
        let decimalB = toDecimal(colorValue: b)
        return (decimalR, decimalG, decimalB)
    }
    
    static func toDecimal(colorValue: Float) -> Int {
        return Int(colorValue * 255)
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
