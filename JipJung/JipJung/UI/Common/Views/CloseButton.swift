//
//  CloseButton.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/15.
//

import UIKit

class CloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        tintColor = UIColor.white
        backgroundColor = .clear
    }
}
