//
//  SolidButton.swift
//  JipJung
//
//  Created by turu on 2021/11/09.
//

import UIKit

class SolidButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func configure() {
        layer.cornerRadius = 8
        self.setTitle("Button", for: .normal)
        self.backgroundColor = .gray
    }
}
