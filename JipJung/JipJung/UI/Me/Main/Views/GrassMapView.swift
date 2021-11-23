//
//  MeGrassView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/23.
//

import UIKit

class GrassMapView: UIView {
    let dayCount = 7
    let weekCount = 20
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
        for _ in 1...20 {
            let weekStackView = UIStackView()
            weekStackView.axis = .vertical
            for _ in 1...7 {
                let dayView = UIView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: MeGrassMapViewSize.cellLength,
                        height: MeGrassMapViewSize.cellLength)))
                dayView.backgroundColor = .green.withAlphaComponent(0.2)
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
