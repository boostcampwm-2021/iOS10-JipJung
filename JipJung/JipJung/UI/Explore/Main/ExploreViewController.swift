//
//  ExploreViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit
import SnapKit

class ExploreViewController: UIViewController {
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var scrollContentView: UIView = UIView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search entire library"
        searchBar.layer.cornerRadius = 3
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        
        return searchBar
    }()
    
    private lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.backgroundColor = .black
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(
            GenreCollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionView.CellIdentifier.genre.value)
        return categoryCollectionView
    }()

    private lazy var soundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let soundContentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        soundContentsCollectionView.backgroundColor = .black
        soundContentsCollectionView.showsHorizontalScrollIndicator = false
        soundContentsCollectionView.delegate = self
        soundContentsCollectionView.dataSource = self
        soundContentsCollectionView.register(
            MusicCollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionView.CellIdentifier.music.value)
        return soundContentsCollectionView
    }()
    
    // MARK: - Private Constants
    
    private let category: [String] = [Genre.All, Genre.Melody, Genre.Relax, Genre.Urban, Genre.Nature, Genre.Techno, Genre.House, Genre.Disco, Genre.Hiphop, Genre.Jazz]

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottomMargin.equalToSuperview()
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        scrollContentView.addSubview(genreCollectionView)
        genreCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        scrollContentView.addSubview(soundCollectionView)
        soundCollectionView.snp.makeConstraints {
            $0.top.equalTo(genreCollectionView.snp.bottom).offset(20)
            $0.height.equalTo(1200)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func presentSearchViewController() {
        let searchViewController = SearchViewController()
        present(searchViewController, animated: true)
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
        presentSearchViewController()
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollectionView {
            return CGSize(width: category[indexPath.item].count * 10, height: 30)
        } else if collectionView == soundCollectionView {
            return CGSize(width: 180, height: 200)
        }
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return category.count
        } else if collectionView == soundCollectionView {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            guard let cell = collectionView.cell(identifier: UICollectionView.CellIdentifier.genre.value, for: indexPath) as? GenreCollectionViewCell else { return  UICollectionViewCell() }
            cell.genreLabel.text = category[indexPath.item]
            return cell
        }
        else if collectionView == soundCollectionView {
            guard let cell = collectionView.cell(identifier: UICollectionView.CellIdentifier.music.value, for: indexPath) as? MusicCollectionViewCell else { return  UICollectionViewCell() }
            return cell
        }
        else {
            return  UICollectionViewCell()
        }
    }
}
