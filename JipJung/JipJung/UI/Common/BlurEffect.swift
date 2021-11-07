//
//  BlurEffect.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import UIKit

import SnapKit

extension UIView {
    func makeBlurBackground(style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
