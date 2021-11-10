//
//  MusicDescriptionView.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

class MusicDescriptionView: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BlueBerry Nights"
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    var subscriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "A blueberry pie and icecrream"
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    var streamingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(white: 1, alpha: 0.8)
        button.setImage(UIImage(systemName: "headphones.circle"), for: .normal)
        return button
    }()
    
    var tagView: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    func configure() {
        let colors: [CGColor] = [.init(gray: 0.0, alpha: 0.5), .init(gray: 0, alpha: 0.0)]
        gradientLayer.colors = colors        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        layer.addSublayer(gradientLayer)
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subscriptionLabel)
        contentView.addSubview(streamingButton)
        contentView.addSubview(tagView)
        
        streamingButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(streamingButton.snp.height)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.equalTo(streamingButton.snp.leading)
            make.centerY.equalTo(streamingButton.snp.centerY)
        }

        subscriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        tagView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(subscriptionLabel.snp.bottom).offset(8)
        }
    }
}
