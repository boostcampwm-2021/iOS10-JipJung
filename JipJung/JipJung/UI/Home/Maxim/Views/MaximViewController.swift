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
    
    private lazy var calendarHeaderCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(
            top: 0,
            left: MaximCalendarHeaderCollectionViewSize.cellSpacing / CGFloat(2),
            bottom: 0,
            right: 0)
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth / 14
        let lineSpacing = cellWidth
        collectionViewLayout.minimumLineSpacing = lineSpacing
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: 100)
        collectionViewLayout.scrollDirection = .horizontal
        
        let headerSize = 50
        let calendarHeaderCollectionView = UICollectionView(
            frame: MaximCalendarHeaderCollectionViewSize.cellSize,
            collectionViewLayout: collectionViewLayout)
        calendarHeaderCollectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: MaximViewSize.headerHeight + MaximViewSize.nocheHeight,
            right: 0)
        calendarHeaderCollectionView.isHidden = true
        calendarHeaderCollectionView.showsHorizontalScrollIndicator = false
        calendarHeaderCollectionView.decelerationRate = .fast
//        calendarHeaderCollectionView.isPagingEnabled = true
        calendarHeaderCollectionView.delegate = self
        calendarHeaderCollectionView.register(
            MaximCalendarHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: MaximCalendarHeaderCollectionViewCell.identifier)
        calendarHeaderCollectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        calendarHeaderCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return calendarHeaderCollectionView
    }()
    
    private lazy var maximCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = UIScreen.main.bounds.size
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 5
        let screenBounds = UIScreen.main.bounds
        let maximCollectionView = UICollectionView(frame: screenBounds, collectionViewLayout: collectionViewLayout)
        maximCollectionView.decelerationRate = .fast
//        maximCollectionView.isPagingEnabled = false
        maximCollectionView.showsHorizontalScrollIndicator = false
        maximCollectionView.delegate = self
        maximCollectionView.translatesAutoresizingMaskIntoConstraints = false
        maximCollectionView.register(
            MaximCollectionViewCell.self,
            forCellWithReuseIdentifier: MaximCollectionViewCell.identifier)
        maximCollectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return maximCollectionView
    }()
    
    private lazy var viewModel: MaximViewModel = {
        let viewModel = MaximViewModel()
        return viewModel
    }()
    
    private var isHeaderPresent = false
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindMaximCollectionView()
        bindAction()
        bindCalendarHeaderCollectionView()
        
        viewModel.fetchMaximList()
    }
    
    private func configureUI() {
        maximCollectionView.backgroundColor = .blue
        view.addSubview(maximCollectionView)
        
        view.addSubview(calendarHeaderCollectionView)
        calendarHeaderCollectionView.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.width.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.top)
            $0.leading.equalToSuperview()
            $0.height.equalTo(200)
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
    }
    
    private func bindMaximCollectionView() {
        viewModel.maximList.bind(to: maximCollectionView.rx.items(cellIdentifier: MaximCollectionViewCell.identifier)) { index, maxim, cell in
            guard let cell = cell as? MaximCollectionViewCell else {
                return
            }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            cell.dayLabel.text = maxim.day
            cell.monthYearLabel.text = maxim.monthYear
            cell.contentLabel.text = maxim.content
            cell.speakerLabel.text = maxim.speaker
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
        ) { _, maxim, cell in
            guard let cell = cell as? MaximCalendarHeaderCollectionViewCell else {
                return
            }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            cell.dayButtonText = maxim.day
            cell.weekdayLabel.text = maxim.weekDay
        }
        .disposed(by: disposeBag)
        let dateObservable = viewModel.selectedDate
        let previousObservable = dateObservable
        let currentObservable = dateObservable.skip(1)
        
        Observable.zip(previousObservable, currentObservable).bind(onNext: { [weak self] (prev, cur) in
            print(prev, cur)
            let previousCell =
            self?.calendarHeaderCollectionView.cellForItem(at: prev) as? MaximCalendarHeaderCollectionViewCell
            let currentCell =
            self?.calendarHeaderCollectionView.cellForItem(at: cur) as? MaximCalendarHeaderCollectionViewCell
            previousCell?.indicatorPointView.isHidden = true
            currentCell?.indicatorPointView.isHidden = false
        })
            .disposed(by: disposeBag)
        // TODO: Today관련 bind
//        viewModel.selectedDate.bind { [weak self] in
//            guard let cell = self?.calendarHeaderCollectionView.cellForItem(at: $0) as? MaximCalendarHeaderCollectionViewCell else {
//                return
//            }
//        }
    }
    
    private func showWeek(with indexPath: IndexPath) {
        let index = indexPath.row / 7
        print(indexPath.row)
        calendarHeaderCollectionView.contentOffset = CGPoint(x: CGFloat(index) * MaximCalendarHeaderCollectionViewSize.width, y: 0)
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
        self.calendarHeaderCollectionView.snp.updateConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.bottom.equalTo(self.view.snp.top).offset(self.calendarHeaderCollectionView.frame.height)
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: []) { [weak self] in
            self?.calendarHeaderCollectionView.superview?.layoutIfNeeded()
        }
    }
    
    private func dismissHeader() {
        self.calendarHeaderCollectionView.snp.updateConstraints { [weak self] in
            guard let self = self else {
                return
            }
            $0.bottom.equalTo(self.view.snp.top)
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: []) { [weak self] in
            self?.calendarHeaderCollectionView.superview?.layoutIfNeeded()
        } completion: { [weak self] in
            self?.calendarHeaderCollectionView.isHidden = $0
        }
    }
}

// MARK: - CollectionViewDelegate
extension MaximViewController: UICollectionViewDelegate {
}

// MARK: 출처 - https://eunjin3786.tistory.com/203
extension MaximViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch scrollView {
        case maximCollectionView:
            guard let layout = maximCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
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
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
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
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
            
        default:
            break
        }
    }
}
