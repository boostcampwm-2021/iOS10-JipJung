//
//  FocusButton.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import UIKit

import SnapKit

final class FocusButton: BlurCircleButton {
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private(set) var mode: FocusMode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func set(mode: FocusMode) {
        self.mode = mode
        let modeValue = FocusMode.getValue(from: mode)
        icon.image = UIImage(systemName: modeValue.image)
        titleLabel.text = modeValue.title
    }
    
    private func configure() {
        configureIcon()
        configureTitle()
    }
    
    private func configureIcon() {
        iconBackground.addSubview(icon)
        icon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconBackground.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
