//
//  CGPoint+Extension.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/18.
//

import CoreGraphics

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> Self {
        return CGPoint(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
}
