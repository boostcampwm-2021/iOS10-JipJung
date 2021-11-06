//
//  DummyCollectionViewCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/05.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    // MARK: - Static Constants
    
    static let cellIdentifier = "CollectionViewCell"
    
    // MARK: - Initializers
       
    override init(frame: CGRect) {
       super.init(frame: frame)
       configureUI()
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        backgroundColor = .darkGray
        layer.cornerRadius = 5
    }
}
