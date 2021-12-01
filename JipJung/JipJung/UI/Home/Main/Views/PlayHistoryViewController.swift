//
//  PlayHistoryViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class PlayHistoryViewController: UIViewController {
    private lazy var playHistoryCollectionView: UICollectionView = {
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
            MediaCollectionViewCell.self,
            forCellWithReuseIdentifier: MediaCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    private let viewModel = PlayHistoryViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
        
        viewModel.viewDidLoad()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "재생 기록"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        view.addSubview(playHistoryCollectionView)
        playHistoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        bindUIwithView()
        bindUIWithViewModel()
    }
    
    private func bindUIwithView() {
        playHistoryCollectionView.rx.modelSelected(Media.self)
            .subscribe(onNext: { [weak self] media in
                let musicPlayerView = MediaPlayerViewController(
                    viewModel: MediaPlayerViewModel(
                        media: media
                    )
                )
                self?.navigationController?.pushViewController(musicPlayerView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUIWithViewModel() {
        viewModel.playHistory
            .bind(
                to: playHistoryCollectionView.rx.items(
                    cellIdentifier: MediaCollectionViewCell.identifier
                )
            ) { (_, element, cell) in
                guard let cell = cell as? MediaCollectionViewCell else { return }

                cell.titleView.text = element.name
                cell.imageView.image = UIImage(named: element.thumbnailImageFileName)
                cell.backgroundColor = UIColor(
                    rgb: Int(element.color, radix: 16) ?? 0xFFFFFF,
                    alpha: 1.0
                )
            }.disposed(by: disposeBag)
    }
}
