//
//  Maxim+Enums.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/18.
//

import UIKit

enum MaximViewSize {
    static let nocheHeight = UIApplication.shared.statusBarFrame.height
    static let headerHeight = CGFloat(50)
}
enum MaximCalendarHeaderCollectionViewSize {
    static let width = UIScreen.deviceScreenSize.width
    static let cellSize = CGRect(
        origin: .zero,
        size: CGSize(
            width: MaximCalendarHeaderCollectionViewSize.width / 14,
            height: MaximCalendarHeaderCollectionViewSize.width / 14 + MaximViewSize.nocheHeight + MaximViewSize.headerHeight * 2))
    static let cellSpacing = MaximCalendarHeaderCollectionViewSize.width / 14
}
