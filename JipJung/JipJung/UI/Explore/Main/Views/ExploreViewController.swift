//
//  ExploreViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ExploreViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private lazy var scrollContentView: UIView = UIView()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search entire library"
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 3
        searchBar.searchTextField.leftView?.tintColor = .gray
        return searchBar
    }()
    private lazy var soundTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SoundTagCollectionViewCell.self)
        return collectionView
    }()
    private lazy var soundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MediaCollectionViewCell.self)
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = ExploreViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ApplicationMode.shared.mode.value == .bright ? .darkContent : .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCommonUI()
        bindUI()
        viewModel.categorize(by: SoundTag.all.value)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
        switch ApplicationMode.shared.mode.value {
        case .bright:
            configureBrightModeUI()
        case .dark:
            configureDarkModeUI()
        }
        soundTagCollectionView.selectItem(
            at: IndexPath(
                item: viewModel.selectedTagIndex,
                section: 0
            ),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
    
    private func configureCommonUI() {
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
            $0.height.equalTo(600)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureBrightModeUI() {
        view.backgroundColor = .white
        scrollView.backgroundColor = .white
        searchBar.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        soundTagCollectionView.backgroundColor = .white
        soundCollectionView.backgroundColor = .white
        
        soundTagCollectionView.reloadData()
        soundCollectionView.reloadData()
    }
    
    private func configureDarkModeUI() {
        view.backgroundColor = .black
        scrollView.backgroundColor = .black
        searchBar.backgroundColor = .black
        searchBar.searchTextField.textColor = .white
        soundTagCollectionView.backgroundColor = .black
        soundCollectionView.backgroundColor = .black
        
        soundTagCollectionView.reloadData()
        soundCollectionView.reloadData()
    }
    
    private func bindUI() {
        ApplicationMode.shared.mode
            .bind { [weak self] in
                switch $0 {
                case .bright:
                    self?.configureBrightModeUI()
                case .dark:
                    self?.configureDarkModeUI()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.categoryItems
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.updateCollectionViewHeight()
                self.soundCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCollectionViewHeight() {
        let defaultHeight = 600
        let height = max(
            defaultHeight,
            (viewModel.categoryItems.value.count + 1)/2 * 280
        )
        
        soundCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == soundTagCollectionView {
            let count = viewModel.soundTagList[safe: indexPath.item]?.value.count ?? 0
            return CGSize(width: count * 14, height: 30)
        } else if collectionView == soundCollectionView {
            let cellWidth = (collectionView.frame.size.width - 32) / 2 - 6
            return CGSize(width: cellWidth, height: cellWidth * MediaCell.ratio)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
}

extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == soundTagCollectionView {
            viewModel.selectedTagIndex = indexPath.item
            let tag = viewModel.soundTagList[safe: indexPath.item]?.value ?? ""
            viewModel.categorize(by: tag)
        } else if collectionView == soundCollectionView {
            let media = viewModel.categoryItems.value[indexPath.item]
            let mediaPlayerViewController = MediaPlayerViewController(
                viewModel: MediaPlayerViewModel(media: media)
            )
            navigationController?.pushViewController(mediaPlayerViewController, animated: true)
        } else {
           return
        }
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == soundTagCollectionView {
            return viewModel.soundTagList.count
        } else if collectionView == soundCollectionView {
            return viewModel.categoryItems.value.count
        } else {
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == soundTagCollectionView {
            guard let cell: SoundTagCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
                return  UICollectionViewCell()
            }
            cell.soundTagLabel.text = viewModel.soundTagList[safe: indexPath.item]?.value
            return cell
        } else if collectionView == soundCollectionView {
            guard let cell: MediaCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
                return  UICollectionViewCell()
            }

            let media = viewModel.categoryItems.value[indexPath.item]
            cell.titleView.text = media.name
            cell.imageView.image = UIImage(named: media.thumbnailImageFileName)
            let colorHexString = viewModel.categoryItems.value[indexPath.item].color
            cell.backgroundColor = UIColor(
                rgb: Int(colorHexString, radix: 16) ?? 0xFFFFFF,
                alpha: 1.0
            ).withAlphaComponent(0.7)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
