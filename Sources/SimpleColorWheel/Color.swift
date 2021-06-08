//
//  Color.swift
//
//
//  Created by shout@claudiu.mn on 2021.06.08.
//

import UIKit

struct Color {
    var r, g, b: UInt8
    var a: UInt8 = 255
    
    static let clear = Color(r: 0, g: 0, b: 0, a: 0)
    
    static let black = Color(r: 0, g: 0, b: 0)
    static let white = Color(r: 255, g: 255, b: 255)

    static let red = Color(r: 255, g: 0, b: 0)
    static let green = Color(r: 0, g: 255, b: 0)
    static let blue = Color(r: 0, g: 0, b: 255)

    static let cyan = Color(r: 0, g: 255, b: 255)
    static let magenta = Color(r: 255, g: 0, b: 255)
    static let yellow = Color(r: 255, g: 255, b: 0)
}
