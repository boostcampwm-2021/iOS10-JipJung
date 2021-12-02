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
    private lazy var calendarHeaderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: MaximCalendarHeaderCollectionViewSize.cellSpacing / CGFloat(2),
            bottom: 0,
            right: MaximCalendarHeaderCollectionViewSize.cellSpacing / CGFloat(2)
        )
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth / 14
        let lineSpacing = cellWidth
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
            bottom: MaximViewSize.headerHeight + MaximViewSize.nocheHeight,
            right: 0
        )
        collectionView.isHidden = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.register(MaximCalendarHeaderCollectionViewCell.self)
        collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return collectionView
    }()
    private lazy var maximCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        let screenBounds = UIScreen.main.bounds
        let collectionView = UICollectionView(
            frame: screenBounds,
            collectionViewLayout: layout
        )
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
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
        bindMaximCollectionView()
        bindAction()
        bindCalendarHeaderCollectionView()
        viewModel.fetchMaximList()
    }
    
    private func configureUI() {
        maximCollectionView.backgroundColor = .systemBackground
        view.addSubview(maximCollectionView)
        view.addSubview(calendarHeaderCollectionView)
        calendarHeaderCollectionView.snp.makeConstraints {
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

        viewModel.selectedDate.skip(1).bind { [weak self] indexPath in
            self?.maximCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
            self?.showWeek(with: indexPath)
        }
        .disposed(by: disposeBag)
    }
    
    private func bindCalendarHeaderCollectionView() {
        viewModel.maximList.bind(
            to: calendarHeaderCollectionView.rx.items(cellIdentifier: MaximCalendarHeaderCollectionViewCell.identifier)
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
            if self.viewModel.selectedDate.value.item == index {
                cell.indicatorPointView.isHidden = false
            } else {
                cell.indicatorPointView.isHidden = true
            }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        .disposed(by: disposeBag)
        
        let dateObservable = viewModel.selectedDate
        let previousObservable = dateObservable
        let currentObservable = dateObservable.skip(1)
        Observable.zip(previousObservable, currentObservable)
            .bind(onNext: { [weak self] (prev, cur) in
            let previousCell =
            self?.calendarHeaderCollectionView.cellForItem(at: prev) as? MaximCalendarHeaderCollectionViewCell
            let currentCell =
            self?.calendarHeaderCollectionView.cellForItem(at: cur) as? MaximCalendarHeaderCollectionViewCell
            previousCell?.indicatorPointView.isHidden = true
            currentCell?.indicatorPointView.isHidden = false
        })
            .disposed(by: disposeBag)
    }
    
    private func showWeek(with indexPath: IndexPath) {
        let index = indexPath.item / 7
        calendarHeaderCollectionView.contentOffset = CGPoint(
            x: CGFloat(index) * MaximCalendarHeaderCollectionViewSize.width,
            y: 0
        )
    }
    
    private func bindAction() {
        closeButton.rx.tap.bind { [weak self] in
            guard let isHeaderPresent = self?.isHeaderPresent else {
                return
            }
            if isHeaderPresent {
                self?.dismissHeader()
                self?.isHeaderPresent = false
            } else {
                self?.dismiss(animated: true)
            }
        }
        .disposed(by: disposeBag)
        
        calendarButton.rx.tap.bind { [weak self] in
            self?.presentHeader()
            self?.viewModel.moveNDate(with: 0)
            self?.isHeaderPresent = true
        }
        .disposed(by: disposeBag)
        
        calendarHeaderCollectionView.rx.itemSelected.bind { [weak self] in
            self?.viewModel.selectDate(with: $0)
        }
        .disposed(by: disposeBag)
    }
    
    private func presentHeader() {
        calendarHeaderCollectionView.isHidden = false
        self.calendarHeaderCollectionView.snp.updateConstraints {
            $0.bottom.equalTo(view.snp.top)
                .offset(calendarHeaderCollectionView.frame.height)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func dismissHeader() {
        self.calendarHeaderCollectionView.snp.updateConstraints {
            $0.bottom.equalTo(view.snp.top)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] in
            self?.calendarHeaderCollectionView.isHidden = $0
        }
    }
}

extension MaximViewController: UICollectionViewDelegate {
}

// 출처 - https://eunjin3786.tistory.com/203
extension MaximViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch scrollView {
        case maximCollectionView:
            guard let layout = maximCollectionView.collectionViewLayout
                    as? UICollectionViewFlowLayout else { return }
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
                viewModel.moveNDate(with: 1)
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
                viewModel.moveNDate(with: -1)
            } else {
                index = Int(round(estimatedIndex))
            }
            targetContentOffset.pointee = CGPoint(
                x: CGFloat(index) * cellWidthIncludingSpacing,
                y: 0
            )
        case calendarHeaderCollectionView:
            guard let layout = calendarHeaderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            let cellWidthIncludingSpacing = (layout.itemSize.width + layout.minimumLineSpacing) * 7
            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
                self.viewModel.moveNDate(with: 7)
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
                self.viewModel.moveNDate(with: -7)
            } else {
                index = Int(round(estimatedIndex))
            }
            targetContentOffset.pointee = CGPoint(
                x: CGFloat(index) * cellWidthIncludingSpacing,
                y: 0
            )
        default:
            break
        }
    }
}
