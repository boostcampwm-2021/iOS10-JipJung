//
//  PlayerMaximView.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

class PlayerMaximView: UIView {
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "This is descriptionTextView"
        textView.isUserInteractionEnabled = false
        return textView
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
        addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}
