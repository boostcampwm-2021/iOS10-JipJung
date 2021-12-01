//
//  MediaDescriptionView.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

final class MediaDescriptionView: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        return label
    }()
    var explanationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    var plusButton: PlusCircleButton = {
        let button = PlusCircleButton()
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return button
    }()
    let tagView = UIView()
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func configure() {
        let colors: [CGColor] = [
            .init(gray: 0.0, alpha: 0.5),
            .init(gray: 0, alpha: 0.0)
        ]
        gradientLayer.colors = colors        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.addSublayer(gradientLayer)
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(explanationLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(tagView)
        
        plusButton.isEnabled = false
        plusButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(titleLabel.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalTo(plusButton.snp.leading)
            $0.centerY.equalTo(plusButton)
        }

        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        tagView.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
