//
//  CategoryCollectionViewCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/08.
//

import UIKit
import SnapKit

class SoundTagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    lazy var soundTagLabel: UILabel = {
        let soundTagLabel = UILabel()
        soundTagLabel.textColor = .lightGray
        soundTagLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return soundTagLabel
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(rgb: 0x00FF80, alpha: 1.0)
                soundTagLabel.textColor = .white
                soundTagLabel.font = .systemFont(ofSize: 17, weight: .bold)
            }
            else {
                backgroundColor = .black
                soundTagLabel.textColor = .lightGray
                soundTagLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            }
        }
    }
    
    // MARK: - Initializers
       
    override init(frame: CGRect) {
       super.init(frame: frame)
       configureUI()
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .black
        layer.cornerRadius = frame.height/2
        
        contentView.addSubview(soundTagLabel)
        soundTagLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
