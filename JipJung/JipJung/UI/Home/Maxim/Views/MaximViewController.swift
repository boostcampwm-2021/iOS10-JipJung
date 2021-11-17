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
    
    private lazy var maximCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = UIScreen.main.bounds.size
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 5
        let screenBounds = UIScreen.main.bounds
        let maximCollectionView = UICollectionView(frame: screenBounds, collectionViewLayout: collectionViewLayout)
        maximCollectionView.decelerationRate = .fast
        maximCollectionView.isPagingEnabled = false
        maximCollectionView.showsHorizontalScrollIndicator = false
        maximCollectionView.delegate = self
        maximCollectionView.register(
            MediaCollectionViewCell.self,
            forCellWithReuseIdentifier: MediaCollectionViewCell.identifier
        )
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
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindCollectionView()
        bindAction()
        
        viewModel.fetchMaximList()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .red
        view.addSubview(maximCollectionView)
        
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
    
    private func bindCollectionView() {
        viewModel.maximLists.bind(to: maximCollectionView.rx.items(cellIdentifier: MaximCollectionViewCell.identifier)) { index, maxim, cell in
            guard let cell = cell as? MaximCollectionViewCell else {
                return
            }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            cell.day.text = maxim.day
            cell.monthYearLabel.text = maxim.monthYear
            cell.contentLabel.text = maxim.content
            cell.speakerLabel.text = maxim.speaker
            cell.backgroundColor = .red
        }
        .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}

// MARK: - CollectionViewDelegate
extension MaximViewController: UICollectionViewDelegate {
}

// MARK: 출처 - https://eunjin3786.tistory.com/203
extension MaximViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = maximCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
}
