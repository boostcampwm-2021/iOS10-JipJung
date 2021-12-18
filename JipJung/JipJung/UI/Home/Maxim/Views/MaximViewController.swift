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
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: MaximCalendarCollectionViewSize.cellWidth * CGFloat(0.5),
            bottom: 0,
            right: MaximCalendarCollectionViewSize.cellWidth * CGFloat(0.5)
        )
        let cellWidth = MaximCalendarCollectionViewSize.cellWidth
        let lineSpacing = MaximCalendarCollectionViewSize.lineSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.itemSize = CGSize(width: cellWidth, height: 100)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: MaximCollectionViewSize.headerHeight + MaximCollectionViewSize.nocheHeight,
            right: 0
        )
        collectionView.isHidden = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.register(MaximCalendarHeaderCollectionViewCell.self)
        collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return collectionView
    }()
    private lazy var maximCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = MaximCollectionViewSize.cellSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = MaximCollectionViewSize.lineSpacing
        let screenBounds = UIScreen.main.bounds
        let collectionView = UICollectionView(
            frame: screenBounds,
            collectionViewLayout: layout
        )
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MaximCollectionViewCell.self)
        collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return collectionView
    }()
    
    private var isHeaderPresent = false
    
    private let viewModel = MaximViewModel()
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bindAction()
        viewModel.fetchMaximList()
    }
    
    private func configureUI() {
        maximCollectionView.backgroundColor = .systemBackground
        view.addSubview(maximCollectionView)
        view.addSubview(calendarCollectionView)
        calendarCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.top)
            $0.height.equalTo(200)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(view.snp.topMargin).offset(10)
            $0.leading.equalToSuperview().offset(30)
        }
        
        view.addSubview(calendarButton)
        calendarButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(view.snp.topMargin).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bindUI() {
        bindMaximCollectionView()
        bindCalendarHeaderCollectionView()
    }
    
    private func bindMaximCollectionView() {
        viewModel.maximList
            .map({$0.compactMap({$0})})
            .bind(to:
                    maximCollectionView.rx.items(
                        cellIdentifier: MaximCollectionViewCell.identifier
                    )
            ) { _, maxim, cell in
                guard let cell = cell as? MaximCollectionViewCell else {
                    return
                }
                cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                cell.dayLabel.text = maxim.day
                cell.monthYearLabel.text = maxim.monthYear
                cell.contentLabel.text = maxim.content
                cell.speakerLabel.text = maxim.speaker
                let backgroundView = UIImageView(
                    image: UIImage(named: maxim.thumbnailImageAssetPath)
                )
                backgroundView.alpha = 0.5
                cell.backgroundView = backgroundView
                cell.isShown = false
            }
            .disposed(by: disposeBag)
        
        maximCollectionView.rx.willDisplayCell.bind {
            guard let cell = $0.cell as? MaximCollectionViewCell else {
                return
            }
            cell.isShown = true
        }
        .disposed(by: disposeBag)
        
        viewModel.jumpedWeek.distinctUntilChanged().bind { [weak self] in
            self?.showCalendarCollectionViewItem(week: $0)
        }
        .disposed(by: disposeBag)
        
        viewModel.jumpedDate.distinctUntilChanged().bind { [weak self] in
            self?.showMaximCollectionViewItem(at: $0)
        }
        .disposed(by: disposeBag)
    }
    
    private func bindCalendarHeaderCollectionView() {
        viewModel.maximList.bind(
            to: calendarCollectionView.rx.items(cellIdentifier: MaximCalendarHeaderCollectionViewCell.identifier)
        ) { index, maxim, cell in
            guard let cell = cell as? MaximCalendarHeaderCollectionViewCell else {
                return
            }
            cell.dayLabel.text = maxim.day
            cell.weekdayLabel.text = maxim.weekDay
            cell.dayButton.setBackgroundImage(
                UIImage(named: maxim.thumbnailImageAssetPath),
                for: .normal
            )
            if self.viewModel.selectedDate.value == index {
                cell.indicatorPointView.isHidden = false
            } else {
                cell.indicatorPointView.isHidden = true
            }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        .disposed(by: disposeBag)
        
        let dateIndexPathObservable = viewModel.selectedDate.map { IndexPath(item: $0, section: 0) }
        let previousObservable = dateIndexPathObservable
        let currentObservable = dateIndexPathObservable.skip(1)
        Observable.zip(previousObservable, currentObservable)
            .bind(onNext: { [weak self] (prev, cur) in
                let previousCell =
                self?.calendarCollectionView.cellForItem(at: prev) as? MaximCalendarHeaderCollectionViewCell
                let currentCell =
                self?.calendarCollectionView.cellForItem(at: cur) as? MaximCalendarHeaderCollectionViewCell
                previousCell?.indicatorPointView.isHidden = true
                currentCell?.indicatorPointView.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Action logic 분리
extension MaximViewController {
    private func bindAction() {
        closeButton.rx.tap.bind { [weak self] in
            guard let isHeaderPresent = self?.isHeaderPresent else {
                return
            }
            if isHeaderPresent {
                self?.dismissHeader()
            } else {
                self?.dismiss(animated: true)
            }
        }
        .disposed(by: disposeBag)
        
        calendarButton.rx.tap.bind { [weak self] in
            self?.presentHeader()
        }
        .disposed(by: disposeBag)
        
        calendarCollectionView.rx.itemSelected.bind { [weak self] in
            self?.viewModel.jumpDate(to: $0.item)
        }
        .disposed(by: disposeBag)
        
        calendarCollectionView.rx.willEndDragging
            .bind { [weak self] velocity, targetContentOffset in
                guard let contentOffset = self?.calendarCollectionView.contentOffset
                else {
                    return
                }
                let pageWidth = MaximCalendarCollectionViewSize.pageWidth
                let estimatedIndex = contentOffset.x / pageWidth
                let index: Int
                if velocity.x > 0 {
                    index = Int(ceil(estimatedIndex))
                } else if velocity.x < 0 {
                    index = Int(floor(estimatedIndex))
                } else {
                    index = Int(round(estimatedIndex))
                }
                
                self?.viewModel.scrollWeek(to: index)
                targetContentOffset.pointee = CGPoint(
                    x: CGFloat(index) * pageWidth,
                    y: 0
                )
            }
            .disposed(by: disposeBag)
        
        maximCollectionView.rx.willEndDragging
            .bind { [weak self] velocity, targetContentOffset in
                guard let contentOffset = self?.maximCollectionView.contentOffset
                else {
                    return
                }
                let pageWidth = MaximCollectionViewSize.pageWidth
                let estimatedIndex = contentOffset.x / pageWidth
                let index: Int
                if velocity.x > 0 {
                    index = Int(ceil(estimatedIndex))
                } else if velocity.x < 0 {
                    index = Int(floor(estimatedIndex))
                } else {
                    index = Int(round(estimatedIndex))
                }
                self?.viewModel.scrollDate(to: index)
                
                targetContentOffset.pointee = CGPoint(
                    x: CGFloat(index) * pageWidth,
                    y: 0
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func presentHeader() {
        calendarCollectionView.isHidden = false
        self.calendarCollectionView.snp.updateConstraints {
            $0.bottom.equalTo(view.snp.top)
                .offset(calendarCollectionView.frame.height)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        isHeaderPresent = true
    }
    
    private func dismissHeader() {
        self.calendarCollectionView.snp.updateConstraints {
            $0.bottom.equalTo(view.snp.top)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] in
            self?.calendarCollectionView.isHidden = $0
            self?.isHeaderPresent = false
        }
    }
    
    private func showMaximCollectionViewItem(at index: Int) {
        maximCollectionView.contentOffset = CGPoint(
            x: CGFloat(index) * MaximCollectionViewSize.pageWidth,
            y: 0
        )
    }
    
    private func showCalendarCollectionViewItem(week: Int) {
        calendarCollectionView.contentOffset = CGPoint(
            x: CGFloat(week) * MaximCalendarCollectionViewSize.pageWidth,
            y: 0
        )
    }
}
