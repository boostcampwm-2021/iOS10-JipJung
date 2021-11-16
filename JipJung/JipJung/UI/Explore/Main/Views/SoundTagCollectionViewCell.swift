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
        soundTagLabel.textColor = .white
        
        return soundTagLabel
    }()
    
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
        addSubview(soundTagLabel)
        soundTagLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
