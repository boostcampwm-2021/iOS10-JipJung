//
//  CategoryCollectionViewCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/08.
//

import UIKit

import SnapKit

final class SoundTagCollectionViewCell: UICollectionViewCell {
    lazy var soundTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(rgb: 0x00FF80, alpha: 1.0)
                soundTagLabel.textColor = .white
                soundTagLabel.font = .systemFont(ofSize: 17, weight: .bold)
            }
            else {
                switch ApplicationMode.shared.mode.value {
                case .bright:
                    backgroundColor = .white
                case .dark:
                    backgroundColor = .black
                }
                soundTagLabel.textColor = .lightGray
                soundTagLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            }
        }
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       configureUI()
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        layer.cornerRadius = frame.height/2
        
        contentView.addSubview(soundTagLabel)
        soundTagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        switch ApplicationMode.shared.mode.value {
        case .bright:
            backgroundColor = .white
        case .dark:
            backgroundColor = .black
        }
    }
}
