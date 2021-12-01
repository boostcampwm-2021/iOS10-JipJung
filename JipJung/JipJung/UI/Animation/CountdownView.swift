//
//  CountdownView.swift
//  JipJung
//
//  Created by turu on 2021/11/23.
//

import UIKit

final class CountdownView: UIView {
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "3"
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2.0
    }
    
    private func configure() {
        backgroundColor = .white
        
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func animate(countdown: Int, completion: @escaping () -> Void) {
        guard countdown > 0 else {
            completion()
            return
        }
        
        self.numberLabel.text = "\(countdown)"
        self.numberLabel.sizeToFit()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.layer.opacity = 0.0
        } completion: { _ in
            self.transform = .identity
            self.layer.opacity = 1.0
            self.animate(countdown: countdown - 1, completion: completion)
        }
    }
}
