//
//  MaximHeaderCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/17.
//

import UIKit

final class MaximCalendarHeaderCollectionViewCell: UICollectionViewCell {
    private(set) lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .gray
        label.text = " "
        return label
    }()
    private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "15"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        return label
    }()
    private(set) lazy var indicatorPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()
    private(set) lazy var dayButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.makeCircle()
        button.backgroundColor = .black
        button.alpha = 0.8
        return button
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
