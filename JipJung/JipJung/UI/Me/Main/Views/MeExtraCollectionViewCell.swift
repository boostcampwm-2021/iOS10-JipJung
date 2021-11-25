//
//  MeExtraCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/23.
//

import UIKit

class MeExtraCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .blue
    }
}
