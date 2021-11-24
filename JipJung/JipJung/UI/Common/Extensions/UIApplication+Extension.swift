//
//  UIApplication+Extension.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/14.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var bottomIndicatorHeight: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            return -1
        }
    }
}
