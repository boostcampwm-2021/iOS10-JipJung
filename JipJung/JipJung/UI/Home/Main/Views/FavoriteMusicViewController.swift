//
//  FavoriteViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class FavoriteViewController: UIViewController {
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cellWidth = (UIScreen.deviceScreenSize.width - 32) / 2 - 6
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * MediaCell.ratio)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MusicCollectionViewCell.self,
            forCellWithReuseIdentifier: MusicCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    private let viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
        
        viewModel.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "좋아요 누른 음원"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]

        view.addSubview(favoriteCollectionView)
        favoriteCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        bindUIwithView()
        bindUIWithViewModel()
    }
    
    private func bindUIwithView() {
        favoriteCollectionView.rx.modelSelected(Media.self)
            .subscribe(onNext: { [weak self] media in
                let musicPlayerView = MusicPlayerViewController(
                    viewModel: MusicPlayerViewModel(
                        media: media
                    )
                )
                self?.navigationController?.pushViewController(musicPlayerView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUIWithViewModel() {
        viewModel.favoriteSoundList
            .bind(
                to: favoriteCollectionView.rx.items(
                    cellIdentifier: MusicCollectionViewCell.identifier
                )
            ) { (item, element, cell) in
                guard let cell = cell as? MusicCollectionViewCell else { return }

                cell.titleView.text = element.name
                cell.imageView.image = UIImage(named: element.thumbnailImageFileName)
                cell.backgroundColor = UIColor(
                    rgb: Int(element.color, radix: 16) ?? 0xFFFFFF,
                    alpha: 1.0
                )
            }.disposed(by: disposeBag)
    }
}
