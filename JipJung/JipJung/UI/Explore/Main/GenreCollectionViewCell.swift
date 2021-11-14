//
//  CategoryCollectionViewCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/08.
//

import UIKit
import SnapKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    lazy var genreLabel: UILabel = {
        let genreLabel = UILabel()
        genreLabel.textColor = .white
        
        return genreLabel
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
        addSubview(genreLabel)
        genreLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
