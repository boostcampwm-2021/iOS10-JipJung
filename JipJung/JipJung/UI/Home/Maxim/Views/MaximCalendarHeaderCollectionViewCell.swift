//
//  MaximHeaderCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/17.
//

import UIKit

final class MaximCalendarHeaderCollectionViewCell: UICollectionViewCell {
    private(set) lazy var weekdayLabel: UILabel = {
        let weekdayLabel = UILabel()
        weekdayLabel.font = .preferredFont(forTextStyle: .title3)
        weekdayLabel.textColor = .gray
        weekdayLabel.text = " "
        return weekdayLabel
    }()
    private(set) lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.text = "15"
        dayLabel.font = .preferredFont(forTextStyle: .headline)
        dayLabel.textColor = .white
        return dayLabel
    }()
    private(set) lazy var indicatorPointView: UIView = {
        let indicatorPointView = UIView()
        indicatorPointView.backgroundColor = .red
        indicatorPointView.isHidden = true
        return indicatorPointView
    }()
    private(set) lazy var dayButton: UIButton = {
        let dayButton = UIButton()
        dayButton.isUserInteractionEnabled = false
        dayButton.makeCircle()
        dayButton.backgroundColor = .black
        dayButton.alpha = 0.8
        return dayButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func prepareForReuse() {
        indicatorPointView.isHidden = true
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
