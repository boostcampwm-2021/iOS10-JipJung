//
//  MeGrassView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/23.
//

import UIKit

class GrassMapView: UIView {
    private let weeksStackView = UIStackView()
    private var monthLabelLists = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        weeksStackView.distribution = .fillEqually
        weeksStackView.axis = .horizontal
        addSubview(weeksStackView)
        weeksStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(MeGrassMapViewSize.height)
        }
        
        for _ in 1...MeGrassMap.weekCount {
            let weekStackView = UIStackView()
            weekStackView.axis = .vertical
            for _ in 1...7 {
                let dayView = UIView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: MeGrassMapViewSize.cellLength,
                        height: MeGrassMapViewSize.cellLength)))
                dayView.backgroundColor = .systemGray3
                dayView.layer.cornerRadius = 5
                weekStackView.addArrangedSubview(dayView)
                weekStackView.distribution = .fillEqually
                weekStackView.spacing = MeGrassMapViewSize.cellSpacing
            }
            weeksStackView.addArrangedSubview(weekStackView)
            weeksStackView.distribution = .fillEqually
            weeksStackView.spacing = MeGrassMapViewSize.cellSpacing
            
            let monthLabel = makeMonthLabel()
            monthLabelLists.append(monthLabel)
            addSubview(monthLabel)
            monthLabel.snp.makeConstraints {
                $0.bottom.equalTo(weekStackView.snp.top)
                $0.centerX.equalTo(weekStackView.snp.centerX)
            }
        }
        
    }
    
    private func makeMonthLabel() -> UILabel {
        let monthLabel = UILabel()
        monthLabel.text = ""
        monthLabel.textColor = MeGrassMap.tintColor
        monthLabel.textAlignment = .center
        monthLabel.font = .systemFont(ofSize: 16)
        return monthLabel
    }
    
    func setMonthLabel(index: Int, month: String) {
        guard (0..<monthLabelLists.count).contains(index) else {
            return
        }
        monthLabelLists[index].text = month
    }
}

extension GrassMapView {
    subscript(_ index: (week: Int, day: Int)) -> UIView? {
        guard (0..<7).contains(index.day),
              (0..<MeGrassMap.weekCount).contains(index.week)
        else {
            return nil
        }
        return weeksStackView.subviews[index.week].subviews[index.day]
    }
}
