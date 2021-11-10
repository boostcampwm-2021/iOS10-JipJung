//
//  FocusHeaderView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/08.
//

import UIKit

class FocusHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        backgroundColor = .systemBlue
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
