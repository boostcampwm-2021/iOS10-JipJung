//
//  MeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MeViewController: UIViewController {
    private var viewModel = MeViewModel()
    private var disposeBag = DisposeBag()
    private var dailyStackView = MeDailyStaticsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavigationbar()
        configureStatisticsView()
        bindDailyStaticsCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFocusTimeLists()
    }
    
    private func configureNavigationbar() {
        self.navigationItem.title = "hi friends"
    }

    private func configureStatisticsView() {
        view.addSubview(dailyStackView)
        dailyStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(dailyStackView.snp.width).dividedBy(0.9)
        }
    }
    
    private func bindDailyStaticsCell() {
        viewModel.grassPresenterObject.bind { [weak self] in
            $0?.stageList.enumerated().forEach({ [weak self] index, value in
                let week = index / 7
                let day = index % 7
                let cell = self?.dailyStackView.grassMapView[(week: week, day: day)]
                cell?.backgroundColor = value.greenColor
            })
        }.disposed(by: disposeBag)
        
        viewModel.monthIndex.bind { [weak self] monthIndexLists in
            monthIndexLists.forEach { [weak self] index, month in
                self?.dailyStackView.grassMapView.setMonthLabel(index: index, month: month)
            }
            
        }
        .disposed(by: disposeBag)
    }
}

