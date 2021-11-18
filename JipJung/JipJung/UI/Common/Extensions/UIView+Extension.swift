//
//  UIView+Extension.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit

extension UIView {
    func makeCircle() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }

    func makeBlurBackground(style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
