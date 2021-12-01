//
//  MediaPlayerMaximView.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

class MediaPlayerMaximView: UIView {
    let maximLabel: UILabel = {
        let label = UILabel()
        let text = """
        At night,
        The moon draws faint tides from ear to ear.
        """
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        label.text = text
        label.setLineSpacing(lineSpacing: 24)
        
        label.lineBreakMode = .byWordWrapping
        if #available(iOS 14.0, *) {
            label.lineBreakStrategy = .hangulWordPriority
        }
        return label
    }()
    
    let speakerNameLabel: UILabel = {
        let label = UILabel()
        let words = "- J.M. Coetzee"
        label.text = words
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(white: 1, alpha: 0.35)
        return label
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
        addSubview(maximLabel)
        addSubview(speakerNameLabel)
        
        maximLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        speakerNameLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(maximLabel.snp.bottom).offset(32)
        }
    }
}
