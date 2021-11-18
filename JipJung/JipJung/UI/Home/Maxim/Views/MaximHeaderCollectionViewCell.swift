//
//  MaximHeaderCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/17.
//

import UIKit

class MaximHeaderCollectionViewCell: UICollectionViewCell {
    private(set) lazy var weekLabel: UILabel = {
        let weekLabel = UILabel()
        weekLabel.font = .systemFont(ofSize: 70)
        weekLabel.textColor = .black
        weekLabel.text = "15"
        return weekLabel
    }()
    
    private(set) lazy var dateButton: UIButton = {
        let dateButton = UIButton()
        dateButton.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
        dateButton.setTitle("17", for: .normal)
        dateButton.setTitleColor(.black, for: .normal)
        return dateButton
    }()
    
    private(set) lazy var indicatorPointView: UIView = {
        let indicatorPointView = UIView()
        indicatorPointView.backgroundColor = .red
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
    
    private func configureUI() {
        addSubview(weekLabel)
        weekLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        addSubview(dateButton)
        dateButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(dateButton.snp.width)
            $0.leading.equalToSuperview()
            $0.top.equalTo(weekLabel.snp.bottom)
        }
        
        addSubview(indicatorPointView)
        indicatorPointView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(dateButton.snp.width)
            $0.leading.equalToSuperview()
            $0.top.equalTo(dateButton.snp.bottom)
        }
        
    }
}
