//
//  TagView.swift
//  JipJung
//
//  Created by turu on 2021/11/09.
//

import UIKit

import SnapKit

class TagCollectionViewCell: UICollectionViewCell {
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cofigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cofigure()
    }
    
    func cofigure() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = 4
        contentView.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
