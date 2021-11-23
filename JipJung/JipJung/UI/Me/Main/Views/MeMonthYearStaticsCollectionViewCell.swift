//
//  MeMonthYearStaticsCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/23.
//

import UIKit

class MeMonthYearStaticsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        backgroundColor = .green
    }
}
