//
//  CGPoint+Circle.swift
//
//
//  Created by shout@claudiu.mn on 07.06.2021.
//

import UIKit

extension CGPoint {
    func pointOnCircleAt(radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = x + radius * cos(angle)
        let y = y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
}
