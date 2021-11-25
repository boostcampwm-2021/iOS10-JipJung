//
//  HomeListHeaderView.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/25.
//

import UIKit

import SnapKit

class HomeListHeaderView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    private(set) lazy var allButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    private func configure() {
        configureTitleLabel()
        configureAllButton()
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    private func configureAllButton() {
        addSubview(allButton)
        allButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(50)
        }
    }
}
