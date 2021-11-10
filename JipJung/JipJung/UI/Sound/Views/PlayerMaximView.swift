//
//  PlayerMaximView.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

class PlayerMaximView: UIView {
    let maximLabel: UILabel = {
        let label = UILabel()
        let words = """
        At night,
        The moon draws faint tides from ear to ear.
        """
        label.font = .italicSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .white
        
        let attrString = NSMutableAttributedString(string: words)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 24
        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attrString.length)
        )
        label.attributedText = attrString
        
        return label
    }()
    
    let personNameLabel: UILabel = {
        let label = UILabel()
        let words = "- J.M. Coetzee"
        label.text = words
        label.font = .italicSystemFont(ofSize: 18)
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
        addSubview(personNameLabel)
        
        maximLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(maximLabel.intrinsicContentSize.height)
        }
        
        personNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(maximLabel.snp.bottom).offset(32)
        }
    }
}
