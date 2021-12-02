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

enum MeGrassMap {
    static let weekCount = 20
    static var dayCount: Int {
        weekCount * 7
    }
    static let tintColor = UIColor.systemGray3
}

enum FocusStage: Int, CaseIterable, CustomStringConvertible {
    case zero, one, two, three, four, five
    
    static func makeFocusStage(withSecond second: Int) -> FocusStage {
        
        return FocusStage(rawValue: Int(ceil(Float(second) / 3600.0))) ?? FocusStage.five
      }
    
    var greenColor: UIColor {
        switch self {
        case .zero:
            return MeGrassMap.tintColor
        case .one:
            return UIColor(rgb: 0xd2f2d4)
        case .two:
            return UIColor(rgb: 0x7be382)
        case .three:
            return UIColor(rgb: 0x26cc00)
        case .four:
            return UIColor(rgb: 0x22b600)            
        case .five:
            return UIColor(rgb: 0x009c1a)
        }
    }
    
    var description: String {
        switch self {
        case .zero:
            return "0H"
        case .one:
            return "~2"
        case .two:
            return "~4"
        case .three:
            return "~6"
        case .four:
            return "~8"
        case .five:
            return "8+"
        }
    }
}
