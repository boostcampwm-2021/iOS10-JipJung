//
//  MeGrassView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/23.
//

import UIKit

class GrassMapView: UIView {
    private let weeksStackView = UIStackView()
    
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
        for _ in 1...MeGrassMap.weekCount {
            let weekStackView = UIStackView()
            weekStackView.axis = .vertical
            for _ in 1...7 {
                let dayView = UIView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: MeGrassMapViewSize.cellLength,
                        height: MeGrassMapViewSize.cellLength)))
                dayView.backgroundColor = .green
                dayView.alpha = 0.2
                weekStackView.addArrangedSubview(dayView)
                weekStackView.distribution = .fillEqually
                weekStackView.spacing = MeGrassMapViewSize.cellSpacing
            }
            weeksStackView.addArrangedSubview(weekStackView)
            weeksStackView.distribution = .fillEqually
            weeksStackView.spacing = MeGrassMapViewSize.cellSpacing
        }
        addSubview(weeksStackView)
        weeksStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(MeGrassMapViewSize.height)
        }
    }
}

extension GrassMapView {
    subscript(_ index: (week: Int, day: Int)) -> UIView? {
        guard index.day < 7,
              index.day >= 0,
              index.week >= 0,
              index.week < MeGrassMap.weekCount
        else {
            return nil
        }
        return weeksStackView.subviews[index.week].subviews[index.day]
    }
}
