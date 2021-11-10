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
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.backgroundColor = .white
    }
}

class PlayerBackButton: PlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        tintColor = .white
    }
}

class FavoriteButton: PlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "heart"), for: .normal)
        tintColor = .white
    }
}

class PlayerBaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func configure() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.35)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircle()
    }
}
