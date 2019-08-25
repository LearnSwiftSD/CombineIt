//
//  Color.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/17/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import Foundation

struct Color {
    
    static func toHex(colorValue: Int) -> String {
        return (hexConvert(colorValue) ?? "<value out of bounds>")
    }
    
    static func toDecimal(colorValue: Float) -> Int {
        return Int(colorValue * 255)
    }
    
    static func toFloat(colorValue: Int) -> Float {
        return Float(colorValue) / 255
    }
    
    private static func hexConvert(_ num: Int) -> String? {
        if num > 255 || num < 0 { return nil }
        let firstHex = Int(num/16)
        let secondHex = Int(num - (firstHex * 16))
        let hexRef = [
            0:"0",1:"1",2:"2",3:"3",4:"4",5:"5",
            6:"6",7:"7",8:"8",9:"9",10:"A",11:"B",
            12:"C",13:"D",14:"E",15:"F"]
        return hexRef[firstHex]! + hexRef[secondHex]!
    }
    
}

extension Color {
    
    /// A simple struct for passing Color Values around
    struct Values {
        
        @Clamping var red: Int
        @Clamping var green: Int
        @Clamping var blue: Int
        
        init(red: Int, green: Int, blue: Int) {
            self._red = Clamping(wrappedValue: red, 0...255)
            self._green = Clamping(wrappedValue: green, 0...255)
            self._blue = Clamping(wrappedValue: blue, 0...255)
        }

        init(red: Float, green: Float, blue: Float) {
            self._red = Clamping(wrappedValue: toDecimal(colorValue: red), 0...255)
            self._green = Clamping(wrappedValue: toDecimal(colorValue: green), 0...255)
            self._blue = Clamping(wrappedValue: toDecimal(colorValue: blue), 0...255)
        }
        
        var float: FloatValues {
            return FloatValues(
                red: toFloat(colorValue: red),
                green: toFloat(colorValue: green),
                blue: toFloat(colorValue: blue)
            )
        }
        
        var hex: String {
            let hexR = toHex(colorValue: red)
            let hexG = toHex(colorValue: green)
            let hexB = toHex(colorValue: blue)
            return hexR + hexG + hexB
        }
        
    }
    
}

extension Color.Values {
    
    struct FloatValues {
        @UnitInterval var red: Float
        @UnitInterval var green: Float
        @UnitInterval var blue: Float
    }
    
}

/// Excellent Wrapper Ideas from https://nshipster.com/propertywrapper/
@propertyWrapper
struct Clamping<Value: Comparable> {
    
    var value: Value
    let range: ClosedRange<Value>
    
    init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        self.value = Self.assign(value, using: range)
        self.range = range
    }

    var wrappedValue: Value {
        get { value }
        set { value = Self.assign(newValue, using: range) }
    }
    
    private static func assign(_ newValue: Value, using agreedRange: ClosedRange<Value>) -> Value {
        return min(max(agreedRange.lowerBound, newValue), agreedRange.upperBound)
    }
    
}

@propertyWrapper
struct UnitInterval<Value: FloatingPoint> {
    
    @Clamping var wrappedValue: Value

    init(wrappedValue value: Value) {
        self._wrappedValue = Clamping(wrappedValue: value, 0...1)
    }
    
}
