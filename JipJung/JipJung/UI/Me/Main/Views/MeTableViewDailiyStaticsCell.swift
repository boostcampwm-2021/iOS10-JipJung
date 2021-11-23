//
//  MeTableViewDailiyStaticsCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/22.
//

import UIKit

final class MeTableViewDailiyStaticsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        self.backgroundColor = .red
    }
}
