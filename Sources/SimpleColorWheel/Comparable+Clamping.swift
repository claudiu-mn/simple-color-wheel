//
//  Comparable+Clamping.swift
//
//
//  Created by shout@claudiu.mn on 2021.06.08.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
