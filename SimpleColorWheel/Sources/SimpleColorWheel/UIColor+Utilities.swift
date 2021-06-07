//
//  UIColor+Utilities.swift
//
//
//  Created by shout@claudiu.mn on 07.06.2021.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let range = 0...255
        
        let redClamped = red.clamped(to: range)
        let greenClamped = green.clamped(to: range)
        let blueClamped = blue.clamped(to: range)
        
        let fRed = CGFloat(redClamped) / CGFloat(range.upperBound)
        let fBlue = CGFloat(blueClamped) / CGFloat(range.upperBound)
        let fGreen = CGFloat(greenClamped) / CGFloat(range.upperBound)
        
        self.init(red: fRed, green: fGreen, blue: fBlue, alpha: 1)
    }
}
