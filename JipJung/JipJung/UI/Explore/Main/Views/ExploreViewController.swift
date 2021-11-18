//
//  ExploreViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ExploreViewController: UIViewController {
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
    
    private lazy var soundTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.backgroundColor = .black
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(
            SoundTagCollectionViewCell.self,
            forCellWithReuseIdentifier: SoundTagCollectionViewCell.identifier)
        return categoryCollectionView
    }()

    private lazy var soundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let soundContentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        soundContentsCollectionView.backgroundColor = .black
        soundContentsCollectionView.showsHorizontalScrollIndicator = false
        soundContentsCollectionView.delegate = self
        soundContentsCollectionView.dataSource = self
        soundContentsCollectionView.register(
            MusicCollectionViewCell.self,
            forCellWithReuseIdentifier: MusicCollectionViewCell.identifier)
        return soundContentsCollectionView
    }()
    
    // MARK: - Private Variables
    
    private var disposeBag: DisposeBag = DisposeBag()
    private var viewModel: ExploreViewModel?

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
        viewModel?.categorize(by: SoundTag.all.value)
        soundTagCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Initializer

    convenience init(viewModel: ExploreViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
        
        scrollContentView.addSubview(soundTagCollectionView)
        soundTagCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        scrollContentView.addSubview(soundCollectionView)
        soundCollectionView.snp.makeConstraints {
            $0.top.equalTo(soundTagCollectionView.snp.bottom).offset(20)
            $0.height.equalTo(1200)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        viewModel?.categoryItems
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.soundCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
        navigationController?.pushViewController(SearchViewController(viewModel: SearchViewModel(searchHistoryUseCase: SearchHistoryUseCase(), searchMediaUseCase: SearchMediaUseCase())),
                                                 animated: true)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == soundTagCollectionView {
            let count = viewModel?.soundTagList[safe: indexPath.item]?.value.count ?? 0
            return CGSize(width: count * 14, height: 30)
        } else if collectionView == soundCollectionView {
            return CGSize(width: (collectionView.frame.size.width-32)/2-6, height: 220)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == soundTagCollectionView {
            let tag = viewModel?.soundTagList[safe: indexPath.item]?.value ?? ""
            viewModel?.categorize(by: tag)
            
        } else if collectionView == soundCollectionView {
            let media = viewModel?.categoryItems.value[indexPath.item] ?? Media()
            navigationController?.pushViewController(MusicPlayerViewController(viewModel: MusicPlayerViewModel(media: media)), animated: true)
        } else {
           return
        }
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == soundTagCollectionView {
            return viewModel?.soundTagList.count ?? 0
        } else if collectionView == soundCollectionView {
            return viewModel?.categoryItems.value.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == soundTagCollectionView {
            guard let cell: SoundTagCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else { return  UICollectionViewCell() }
            cell.soundTagLabel.text = viewModel?.soundTagList[safe: indexPath.item]?.value
            return cell
        } else if collectionView == soundCollectionView {
            guard let cell: MusicCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else { return  UICollectionViewCell() }

            let media = viewModel?.categoryItems.value[indexPath.item] ?? Media()
            cell.titleView.text = media.name
            cell.imageView.image = UIImage(named: media.thumbnailImageFileName)
            let colorHexString = viewModel?.categoryItems.value[indexPath.item].color ?? "FFFFFF"
            cell.backgroundColor = UIColor(rgb: Int(colorHexString, radix: 16) ?? 0xFFFFFF,
                                           alpha: 1.0).withAlphaComponent(0.7)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
