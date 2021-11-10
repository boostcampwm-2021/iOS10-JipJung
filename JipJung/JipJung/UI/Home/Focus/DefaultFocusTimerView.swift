//
//  FocusTimerView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit

class DefaultFocusTimerView: UIView, FocusTimerViewable {
    weak var delegate: FocusTimerViewDelegate?
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시작안함"
        label.textColor = .secondarySystemGroupedBackground
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
//        backgroundColor = .systemBackground
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }
    
    func startFocus(with time: String) {
        timeLabel.text = time
    }
    
    func endFocus() {
        timeLabel.text = "종료"
    }
    
    func changeTime(with time: String) {
        timeLabel.text = time
    }
}
