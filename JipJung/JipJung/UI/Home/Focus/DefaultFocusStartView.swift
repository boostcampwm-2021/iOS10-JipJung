//
//  FocusStartView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit

class DefaultFocusStartView: UIView, FocusStartViewable {
    weak var delegate: FocusStarViewDelegate?
    lazy var startButton: UIButton = {
        let startButton = UIButton(type: .custom)
        startButton.setTitle("시작", for: .normal)
        startButton.setTitleColor(.systemRed, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 24)
        startButton.layer.borderColor = UIColor.systemRed.cgColor
        startButton.layer.borderWidth = 3
        startButton.layer.cornerRadius = 5
        startButton.addTarget(self, action: #selector(self.clickStartButton(_:)), for: .touchUpInside)
        return startButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .systemGray
        addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }
    
    func startFocus() {
        startButton.setTitle("시작", for: .normal)
    }
    
    func endFocus() {
        startButton.setTitle("정지", for: .normal)
    }
    
    @IBAction func clickStartButton(_ sender: UIButton) {
        delegate?.startButtonDidClicked()
    }
    
    func logngtab(_ sender: UIButton) {
        delegate?.endButtonDidClicked()
    }
}
