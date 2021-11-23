//
//  MeHeaderCollectionReusableView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/22.
//

import UIKit

class MeHeaderCollectionReusableView: UICollectionReusableView {
    static var identifier: String {
        String(describing: self)
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
        backgroundColor = .brown
    }
}
