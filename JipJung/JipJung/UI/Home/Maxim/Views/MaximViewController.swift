//
//  MaximViewController.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import UIKit
import RxCocoa
import RxSwift

final class MaximViewController: UIViewController {
    private lazy var closeButton: UIButton = {
        let button = CloseButton()
        button.tintColor = .white
        return button
    }()
    
    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .white
        button.imageView?.frame = .init(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .systemFont(ofSize: 70)
        dayLabel.textColor = .white
        dayLabel.text = "15"
        return dayLabel
    }()
    
    private lazy var monthYearLabel: UILabel = {
        let monthYearLabel = UILabel()
        monthYearLabel.font = .systemFont(ofSize: 20)
        monthYearLabel.textColor = .white
        monthYearLabel.text = "NOV 2021"
        return monthYearLabel
    }()

    private lazy var maximLabel: UILabel = {
        let maximLabel = UILabel()
        maximLabel.font = .systemFont(ofSize: 26, weight: .bold)
        maximLabel.textColor = .white
        maximLabel.text = "In fact, in order to understand the real Chinaman, and the Chinese civilisation, a man must be depp, broad and simple."
        maximLabel.numberOfLines = 0
        maximLabel.setLineSpacing(lineSpacing: 4)
        return maximLabel
    }()
    
    private lazy var seperateLine: UIView = {
        let seperateLine = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 5))
        seperateLine.backgroundColor = .systemGray3
        return seperateLine
    }()
    
    private lazy var speakerNameLabel: UILabel = {
        let speakerNameLabel = UILabel()
        speakerNameLabel.font = .italicSystemFont(ofSize: 24)
        speakerNameLabel.textColor = .systemGray3
        speakerNameLabel.text = "Schloar, Gu Hongming"
        return speakerNameLabel
    }()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .red
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.width.equalTo(30)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(30)
        }
        
        view.addSubview(calendarButton)
        calendarButton.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.width.equalTo(30)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        view.addSubview(speakerNameLabel)
        speakerNameLabel.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.addSubview(seperateLine)
        seperateLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(speakerNameLabel.snp.top).offset(-20)
            $0.width.equalTo(30)
            $0.height.equalTo(5)
        }
        
        view.addSubview(maximLabel)
        maximLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(seperateLine.snp.top).offset(-30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        view.addSubview(monthYearLabel)
        monthYearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(maximLabel.snp.top).offset(-30)
        }
        
        view.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(monthYearLabel.snp.top)
        }
    }
    
    private func bindUI() {
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
