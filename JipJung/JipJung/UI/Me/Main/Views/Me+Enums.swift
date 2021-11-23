//
//  Me+Enums.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/22.
//

import UIKit

enum MeCollectionViewSize {
    static let space = CGFloat(10)
    static let width = UIScreen.deviceScreenSize.width - space * 2
}

enum MeGrassMapViewSize {
    static let offset = CGFloat(30)
    static let width = MeCollectionViewSize.width - offset * 2
    static let cellSpacing = CGFloat(1)
    static let cellLength = (width - 19 * cellSpacing) / 20
    static let height = cellLength * 7 + cellSpacing * 6
}
