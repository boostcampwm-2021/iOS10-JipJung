//
//  MaximHeaderCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/17.
//

import UIKit

class MaximCalendarHeaderCollectionViewCell: UICollectionViewCell {
    private(set) lazy var weekdayLabel: UILabel = {
        let weekdayLabel = UILabel()
        weekdayLabel.font = .systemFont(ofSize: 20)
        weekdayLabel.textColor = .gray
        weekdayLabel.text = " "
        return weekdayLabel
    }()
    
    private lazy var dayButton: UIButton = {
        let dayButton = UIButton()
        dayButton.isUserInteractionEnabled = false
        dayButton.makeCircle()
        dayButton.backgroundColor = .black
        return dayButton
    }()

    var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.text = "15"
        dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dayLabel.textColor = .white
        return dayLabel
    }()
    
    var dayButtonImageName: String = "" {
        didSet {
            dayButton.setBackgroundImage(UIImage(named: dayButtonImageName), for: .normal)
            dayButton.backgroundColor = .black
            dayButton.alpha = 0.8
        }
    }
    
    private lazy var indicatorPointView: UIView = {
        let indicatorPointView = UIView()
        indicatorPointView.backgroundColor = .red
        indicatorPointView.isHidden = true
        return indicatorPointView
    }()
    
    var indicatorPointViewIsHidden: Bool {
        get {
            indicatorPointView.isHidden
        }
        set {
            indicatorPointView.isHidden = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if dayButton.frame.contains(point) {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorPointView.makeCircle()
        dayButton.makeCircle()
    }
    
    private func configureUI() {
        addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        addSubview(dayButton)
        dayButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(dayButton.snp.width)
            $0.leading.equalToSuperview()
            $0.top.equalTo(weekdayLabel.snp.bottom).offset(8)
        }
        
        addSubview(indicatorPointView)
        indicatorPointView.snp.makeConstraints {
            $0.width.equalTo(5)
            $0.height.equalTo(indicatorPointView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dayButton.snp.bottom).offset(10)
        }
        
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(dayButton)
        }
    }
}
