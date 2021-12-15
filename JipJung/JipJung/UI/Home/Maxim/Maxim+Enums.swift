//
//  Maxim+Enums.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/18.
//

import UIKit

enum MaximCollectionViewSize {
    static let nocheHeight = UIApplication.statusBarHeight
    static let headerHeight = CGFloat(50)
    static let cellSize = UIScreen.main.bounds.size
    static let lineSpacing = CGFloat(2)
    static let pageWidth = (cellSize.width + lineSpacing)
}

enum MaximCalendarCollectionViewSize {
    static let contentWidth = UIScreen.deviceScreenSize.width
    static let size = CGRect(
        origin: .zero,
        size: CGSize(
            width: Self.contentWidth / 14,
            height: Self.contentWidth / 14
            + MaximCollectionViewSize.nocheHeight
            + MaximCollectionViewSize.headerHeight * 2
        )
    )
    static let cellWidth = Self.contentWidth / 14
    static let lineSpacing = cellWidth
    static let pageWidth = (cellWidth + lineSpacing) * 7
}
