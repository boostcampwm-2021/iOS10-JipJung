//
//  MeDailiyStaticsCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/22.
//

import UIKit

class MeDailiyStaticsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .red
    }
}
