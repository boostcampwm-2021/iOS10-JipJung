//
//  MeDailiyStaticsCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/22.
//

import UIKit

class MeDailyStaticsCollectionViewCell: UICollectionViewCell {
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "11월 11일 ~ 11월 12일"
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 36, weight: .bold)
        return dateLabel
    }()
    
    private lazy var totalFocusStackView: UIStackView = {
        return makeFocusRepresentativeValueStackViewStackView(category: "Total")
    }()
    
    private lazy var averageFocusStackView: UIStackView = {
        return makeFocusRepresentativeValueStackViewStackView(category: "Average")
    }()
    
    private lazy var representativeValuesStackView: UIStackView = {
        let representativeValuesStackView = UIStackView()
        representativeValuesStackView.addArrangedSubview(totalFocusStackView)
        representativeValuesStackView.addArrangedSubview(averageFocusStackView)
        representativeValuesStackView.distribution = .equalSpacing
        return representativeValuesStackView
    }()
    
    var grassMapView: UIView = {
        let grassMapView = UIView()
        grassMapView.backgroundColor = .green
        return grassMapView
    }()
    
    // MARK: 평균, 총합 등의 대표값이란 의미에서 RepresentativeValue를 썼습니다.
    private func makeFocusRepresentativeValueStackViewStackView(category: String) -> UIStackView {
        let representativeValueStackView = UIStackView()
        representativeValueStackView.axis = .vertical
        representativeValueStackView.alignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "0"
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 24)
        
        let titleLabel = UILabel()
        titleLabel.text = "\(category) Focus Minute"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        
        representativeValueStackView.addArrangedSubview(descriptionLabel)
        representativeValueStackView.addArrangedSubview(titleLabel)
        return representativeValueStackView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .red
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
        }
        
        addSubview(representativeValuesStackView)
        representativeValuesStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        addSubview(grassMapView)
        grassMapView.snp.makeConstraints {
            $0.top.equalTo(representativeValuesStackView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}
