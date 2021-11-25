//
//  UIColor+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/18.
//
import UIKit

// 참고: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
       self.init(
           red: CGFloat((rgb >> 16) & 0xFF)/255,
           green: CGFloat((rgb >> 8) & 0xFF)/255,
           blue: CGFloat(rgb & 0xFF)/255,
           alpha: alpha
       )
    }
}
