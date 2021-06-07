//
//  Comparable+Clamping.swift
//
//
//  Created by shout@claudiu.mn on 07.06.2021.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
