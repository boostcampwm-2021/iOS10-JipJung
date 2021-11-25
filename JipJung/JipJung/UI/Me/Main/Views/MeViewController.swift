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
    private var dailyStatisticsView = MeDailyStaticsView()
    
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
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(dailyStatisticsView.snp.width).multipliedBy(1.1)
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
            self?.dailyStatisticsView.dateLabelText = $0?.statisticsPeriod
        }.disposed(by: disposeBag)
        
        viewModel.monthIndex.bind { [weak self] monthIndexLists in
            monthIndexLists.forEach { [weak self] index, month in
                self?.dailyStatisticsView.grassMapView.setMonthLabel(index: index, month: month)
            }
            
        }
        .disposed(by: disposeBag)
    }
}
