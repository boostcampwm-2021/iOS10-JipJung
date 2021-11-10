//
//  PlayerBaseButton.swift
//  JipJung
//
//  Created by turu on 2021/11/11.
//

import UIKit

final class PlayerBackButton: PlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        tintColor = .white
    }
}

final class FavoriteButton: PlayerBaseButton {
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
