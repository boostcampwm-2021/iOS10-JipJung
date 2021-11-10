//
//  FocusTimerView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit

class DefaultFocusTimerView: UIView {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .red
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    @IBAction func selec(_ sender: Any) {
        print(3)
    }
}
