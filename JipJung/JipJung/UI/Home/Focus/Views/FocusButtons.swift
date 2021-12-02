//
//  FocusButtons.swift
//  JipJung
//
//  Created by turu on 2021/11/30.
//

import UIKit

final class FocusStartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tintColor = .gray
        let playImage = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        setImage(playImage, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        setTitle("Start", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        setTitleColor(UIColor.gray, for: .normal)
        layer.cornerRadius = 25
        backgroundColor = .white
    }
}

final class FocusContinueButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tintColor = .gray
        setTitle("Continue", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.gray, for: .normal)
        layer.cornerRadius = 25
        backgroundColor = .white
    }
}

final class FocusPauseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitle("Pause", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 25
        backgroundColor = .gray
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
}

final class FocusExitButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitle("Exit", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 25
        backgroundColor = .gray
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
}
