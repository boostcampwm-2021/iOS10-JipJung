//
//  CloseButton.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/15.
//

import UIKit

final class CloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        var font: UIFont = .preferredFont(forTextStyle: .title2)
        if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
            font = UIFont(descriptor: fontDescriptor, size: 0)
        }
        
        titleLabel?.font = font
        tintColor = UIColor.white
        backgroundColor = .clear
    }
}
