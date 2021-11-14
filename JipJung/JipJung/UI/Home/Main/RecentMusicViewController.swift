//
//  RecentMusicViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/08.
//

import Foundation
import UIKit

final class RecentMusicViewController: UIViewController {
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var scrollContentView: UIView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Recent"
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private lazy var recentMusicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let recentMusicCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recentMusicCollectionView.backgroundColor = .black
        recentMusicCollectionView.showsHorizontalScrollIndicator = false
        recentMusicCollectionView.delegate = self
        recentMusicCollectionView.dataSource = self
        recentMusicCollectionView.register(MusicCollectionViewCell.self,
                                           forCellWithReuseIdentifier: UICollectionView.CellIdentifier.music.value)
        return recentMusicCollectionView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.topMargin.leading.trailing.bottomMargin.equalToSuperview()
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        scrollContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        scrollContentView.addSubview(recentMusicCollectionView)
        recentMusicCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(70)
            $0.height.equalTo(1200)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension RecentMusicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension RecentMusicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.cell(identifier: UICollectionView.CellIdentifier.music.value, for: indexPath) as? MusicCollectionViewCell else { return  UICollectionViewCell() }
        
        return cell
    }
}
