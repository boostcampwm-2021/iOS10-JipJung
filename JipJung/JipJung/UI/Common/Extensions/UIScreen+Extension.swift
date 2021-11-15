//
//  UIScreen+Extension.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/14.
//

import UIKit

extension UIScreen {
    static var deviceScreenSize: CGSize {
        CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
    }
}
