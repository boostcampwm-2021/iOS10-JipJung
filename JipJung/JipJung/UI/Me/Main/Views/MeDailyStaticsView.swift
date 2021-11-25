//
//  MeDailiyStaticsCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/22.
//

import UIKit

class MeDailyStaticsView: UIView {
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "11월 11일 ~ 11월 12일"
        dateLabel.textColor = .systemGray
        dateLabel.font = .systemFont(ofSize: 28, weight: .bold)
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
    
    var grassMapView = GrassMapView()
    
    private lazy var unitDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "단위: 시간(H)"
        label.font = .systemFont(ofSize: 12)
        label.textColor = MeGrassMap.tintColor
        return label
    }()
    
    private lazy var stageColorDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .fill
        makeColorDescriptionViewList().forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    func makeColorDescriptionViewList() -> [UIView] {
        return FocusStage
            .allCases
            .dropFirst()
            .map {
                let colorDescriptionView = UIView()
            colorDescriptionView.translatesAutoresizingMaskIntoConstraints = false
            
            let colorMarkerView = UIView()
            colorMarkerView.backgroundColor = $0.greenColor
            colorDescriptionView.addSubview(colorMarkerView)
            colorMarkerView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.height.width.equalTo(MeGrassMapViewSize.cellLength)
            }
            
            let colorDescriptionLabel = UILabel()
            colorDescriptionLabel.textColor = MeGrassMap.tintColor
            colorDescriptionLabel.font = .systemFont(ofSize: 20)
            colorDescriptionLabel.text = "\($0)"
            colorDescriptionLabel.adjustsFontSizeToFitWidth = true
            colorDescriptionView.addSubview(colorDescriptionLabel)
            colorDescriptionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(colorMarkerView.snp.trailing).offset(10)
            }

            return colorDescriptionView
        }
    }

    // MARK: 평균, 총합 등의 대표값이란 의미에서 RepresentativeValue를 썼습니다.
    private func makeFocusRepresentativeValueStackViewStackView(category: String) -> UIStackView {
        let representativeValueStackView = UIStackView()
        representativeValueStackView.axis = .vertical
        representativeValueStackView.alignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "0"
        descriptionLabel.textColor = .systemGray
        descriptionLabel.font = .systemFont(ofSize: 24)
        
        let titleLabel = UILabel()
        titleLabel.text = "\(category) Focus Hours"
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 16)
        
        representativeValueStackView.addArrangedSubview(descriptionLabel)
        representativeValueStackView.addArrangedSubview(titleLabel)
        return representativeValueStackView
    }
    
    var dateLabelText: String? {
        get {
            return dateLabel.text
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    var totalFocusLabelText: String? {
        get {
            return (totalFocusStackView.subviews.first as? UILabel)?.text
        }
        set {
            (totalFocusStackView.subviews.first as? UILabel)?.text = newValue
        }
    }
    
    var averageFocusLabelText: String? {
        get {
            return (averageFocusStackView.subviews.first as? UILabel)?.text
        }
        set {
            (averageFocusStackView.subviews.first as? UILabel)?.text = newValue
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
    
    func configureUI() {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
        
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
            $0.bottom.equalToSuperview().offset(-80)
        }
        
        addSubview(unitDescriptionLabel)
        unitDescriptionLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().offset(-20)
        }
        
        addSubview(stageColorDescriptionStackView)
        stageColorDescriptionStackView.snp.makeConstraints {
            $0.top.equalTo(grassMapView.snp.bottom).offset(30)
            $0.bottom.equalTo(unitDescriptionLabel.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().offset(-20).priority(751)
        }
    }
}
