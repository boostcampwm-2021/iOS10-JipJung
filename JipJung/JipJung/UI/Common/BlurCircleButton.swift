//
//  BlurCircleButton.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import UIKit

import SnapKit

class BlurCircleButton: UIView {
    let iconBackground: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.makeBlurBackground()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconBackground.layer.cornerRadius = bounds.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        configureIconBackground()
    }
    
    private func configureIconBackground() {
        addSubview(iconBackground)
        iconBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(iconBackground.snp.width)
        }
    }
}
