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
        maximCollectionView.dataSource = self
        maximCollectionView.register(
            MediaCollectionViewCell.self,
            forCellWithReuseIdentifier: MediaCollectionViewCell.identifier
        )
        maximCollectionView.translatesAutoresizingMaskIntoConstraints = false
        maximCollectionView.register(
            MaximCollectionViewCell.self,
            forCellWithReuseIdentifier: MaximCollectionViewCell.identifier)
        maximCollectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
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
        bindAction()
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
    
    private func bind() {
        Observable.zip(viewModel.date, viewModel.monthYear, viewModel.content, viewModel.speaker)
    }
    
    private func bind(on cell: MaximCollectionViewCell) {
        viewModel.date.bind { [weak self] in
            cell.dateLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.monthYear.bind { [weak self] in
            cell.monthYearLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.content.bind { [weak self] in
            cell.contentLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.speaker.bind { [weak self] in
            cell.speakerLabel.text = $0
        }
        .disposed(by: disposeBag)
        
        viewModel.imageURL.bind { [weak self] in
            cell.backgroundView = UIImageView(image: UIImage(contentsOfFile: $0) ?? UIImage(systemName: "xmark"))
        }
        .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}

// MARK: - CollectionViewDelegate & DataSource
extension MaximViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaximCollectionViewCell.identifier, for: indexPath) as? MaximCollectionViewCell else {
            return UICollectionViewCell()
        }
        bind(on: cell)
        cell.backgroundColor = .red
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return cell
    }
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
