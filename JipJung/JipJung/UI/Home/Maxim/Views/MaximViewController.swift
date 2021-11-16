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
    
    private var backgroundView = UIImageView()
    
    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .white
        button.imageView?.frame = .init(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 70)
        dateLabel.textColor = .white
        dateLabel.text = "15"
        return dateLabel
    }()
    
    private lazy var monthYearLabel: UILabel = {
        let monthYearLabel = UILabel()
        monthYearLabel.font = .systemFont(ofSize: 20)
        monthYearLabel.textColor = .white
        monthYearLabel.text = "NOV 2021"
        return monthYearLabel
    }()

    private lazy var contentLabel: UILabel = {
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
    
    private lazy var speakerLabel: UILabel = {
        let speakerLabel = UILabel()
        speakerLabel.font = .italicSystemFont(ofSize: 24)
        speakerLabel.textColor = .systemGray3
        speakerLabel.text = "Schloar, Gu Hongming"
        return speakerLabel
    }()
    
    private lazy var viewModel: MaximViewModel = {
        let viewModel = MaximViewModel()
        return viewModel
    }()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindAction()
    }
    
    private func configureUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
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
        
        view.addSubview(speakerLabel)
        speakerLabel.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.addSubview(seperateLine)
        seperateLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(speakerLabel.snp.top).offset(-20)
            $0.width.equalTo(30)
            $0.height.equalTo(5)
        }
        
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(seperateLine.snp.top).offset(-30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        view.addSubview(monthYearLabel)
        monthYearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(contentLabel.snp.top).offset(-30)
        }
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(monthYearLabel.snp.top)
        }
    }
    
    private func bindUI() {
        viewModel.date.bind { [weak self] in
            self?.dateLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.monthYear.bind { [weak self] in
            self?.monthYearLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.content.bind { [weak self] in
            self?.contentLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.speaker.bind { [weak self] in
            self?.speakerLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.imageURL.bind { [weak self] in
            self?.backgroundView.image = UIImage(contentsOfFile: $0) ?? UIImage(systemName: "xmark")
        }
        .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
