//
//  MaximCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/16.
//

import UIKit

final class MaximCollectionViewCell: UICollectionViewCell {
    private(set) lazy var closeButton: UIButton = {
        let button = CloseButton()
        button.tintColor = .white
        return button
    }()
    
    private(set) lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .white
        button.imageView?.frame = .init(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    private(set) lazy var day: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 70)
        dateLabel.textColor = .white
        dateLabel.text = "15"
        return dateLabel
    }()
    
    private(set) lazy var monthYearLabel: UILabel = {
        let monthYearLabel = UILabel()
        monthYearLabel.font = .systemFont(ofSize: 20)
        monthYearLabel.textColor = .white
        monthYearLabel.text = "NOV 2021"
        return monthYearLabel
    }()

    private(set) lazy var contentLabel: UILabel = {
        let maximLabel = UILabel()
        maximLabel.font = .systemFont(ofSize: 26, weight: .bold)
        maximLabel.textColor = .white
        maximLabel.text = "In fact, in order to understand the real Chinaman, and the Chinese civilisation, a man must be depp, broad and simple."
        maximLabel.numberOfLines = 0
        maximLabel.setLineSpacing(lineSpacing: 4)
        return maximLabel
    }()
    
    private(set) lazy var seperateLine: UIView = {
        let seperateLine = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 5))
        seperateLine.backgroundColor = .systemGray3
        return seperateLine
    }()
    
    private(set) lazy var speakerLabel: UILabel = {
        let speakerLabel = UILabel()
        speakerLabel.font = .italicSystemFont(ofSize: 24)
        speakerLabel.textColor = .systemGray3
        speakerLabel.text = "Schloar, Gu Hongming"
        return speakerLabel
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
        addSubview(speakerLabel)
        speakerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addSubview(seperateLine)
        seperateLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(speakerLabel.snp.top).offset(-20)
            $0.width.equalTo(30)
            $0.height.equalTo(5)
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(seperateLine.snp.top).offset(-30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        addSubview(monthYearLabel)
        monthYearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(contentLabel.snp.top).offset(-30)
        }
        
        addSubview(day)
        day.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(monthYearLabel.snp.top)
        }
    }
}
