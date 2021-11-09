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
        label.text = "title"
        label.font = .systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    var subscriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "subTitle"
        return label
    }()
    
    var streamingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "headphones.circle"), for: .normal)
        return button
    }()
    
    var tagView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        self.addSubview(titleLabel)
        self.addSubview(subscriptionLabel)
        self.addSubview(streamingButton)
        self.addSubview(tagView)
        
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
