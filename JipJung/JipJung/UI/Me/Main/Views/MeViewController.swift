//
//  MeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class MeViewController: UIViewController {
    private lazy var dailyStatisticsView = MeDailyStaticsView()
    
    private let viewModel = MeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavigationbar()
        configureLayout()
        bindDailyStaticsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFocusTimeLists()
    }
    
    private func configureNavigationbar() {
        self.navigationItem.title = "통계"
    }
    
    private func configureLayout() {
        view.addSubview(dailyStatisticsView)
        dailyStatisticsView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(16)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.greaterThanOrEqualTo(dailyStatisticsView.snp.width)
        }
    }
    
    private func bindDailyStaticsView() {
        viewModel.grassPresenterObject.bind { [weak self] in
            $0?.stageList.enumerated().forEach({ [weak self] index, value in
                let week = index / 7
                let day = index % 7
                let cell = self?.dailyStatisticsView.grassMapView[(week: week, day: day)]
                cell?.backgroundColor = value.greenColor
            })
            self?.dailyStatisticsView.totalFocusLabelText = $0?.totalFocusHour
            self?.dailyStatisticsView.averageFocusLabelText = $0?.averageFocusHour
            self?.dailyStatisticsView.dateLabel.text = $0?.statisticsPeriod
        }.disposed(by: disposeBag)
        
        viewModel.monthIndex.bind { [weak self] monthIndexLists in
            monthIndexLists.forEach { [weak self] index, month in
                self?.dailyStatisticsView.grassMapView.setMonthLabel(index: index, month: month)
            }
            
        }
        .disposed(by: disposeBag)
    }
}
