//
//  MusicPlayerButtons.swift
//  JipJung
//
//  Created by turu on 2021/11/11.
//

import UIKit

class MusicPlayerBaseButton: UIButton {
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

final class BackCircleButton: MusicPlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        tintColor = .white
    }
}

final class FavoriteCircleButton: MusicPlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "heart"), for: .normal)
        tintColor = .white
    }
}
