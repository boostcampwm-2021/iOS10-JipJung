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
        weekdayLabel.text = "Today"
        return weekdayLabel
    }()
    
    private lazy var dayButton: UIButton = {
        let dayButton = UIButton()
        dayButton.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
        dayButton.setTitle("17", for: .normal)
        dayButton.titleLabel?.font = .systemFont(ofSize: 24)
        dayButton.setTitleColor(.black, for: .normal)
        dayButton.isUserInteractionEnabled = false
        dayButton.makeCircle()
        return dayButton
    }()
    
    var dayButtonText: String {
        get {
            dayButton.titleLabel?.text ?? ""
        }
        set {
            dayButton.setTitle(newValue, for: .normal)
        }
    }
    
    var dayButtonImageName: String = "" {
        didSet {
            dayButton.setBackgroundImage(UIImage(named: dayButtonImageName), for: .normal)
        }
    }
    
    private(set) lazy var indicatorPointView: UIView = {
        let indicatorPointView = UIView()
        indicatorPointView.backgroundColor = .red
        indicatorPointView.isHidden = true
        return indicatorPointView
    }()
    
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
    }
}
