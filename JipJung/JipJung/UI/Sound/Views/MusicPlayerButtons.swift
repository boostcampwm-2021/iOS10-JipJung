//
//  MediaPlayerButtons.swift
//  JipJung
//
//  Created by turu on 2021/11/11.
//

import UIKit

class MediaPlayerBaseButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircle()
    }
    
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
}

final class BackCircleButton: MediaPlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        tintColor = .white
    }
}

final class FavoriteCircleButton: MediaPlayerBaseButton {
    override func configure() {
        super.configure()
        setImage(UIImage(systemName: "heart"), for: .normal)
        setImage(UIImage(systemName: "heart.fill"), for: .selected)
        tintColor = .red
    }
}

final class PlusCircleButton: MediaPlayerBaseButton {
    override func configure() {
        super.configure()
        self.backgroundColor = .clear
        setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        tintColor = .lightGray
    }
}
