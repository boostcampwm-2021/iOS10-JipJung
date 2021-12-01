//
//  SearchViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class SearchViewController: UIViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search entire library"
        searchBar.layer.cornerRadius = 3
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftView?.tintColor = .gray
        return searchBar
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar, cancelButton])
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    private lazy var searchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        return tableView
    }()
    private lazy var soundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            MusicCollectionViewCell.self,
            forCellWithReuseIdentifier: MusicCollectionViewCell.identifier
        )
        return collectionView
    }()
    private lazy var emptySearchResultView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    private lazy var emptySearchResultLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.text = "검색된 결과가 없습니다."
        label.font = .systemFont(ofSize: 17)
        label.textColor = ApplicationMode.shared.mode.value == .bright ? .black : .white
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    private var cellDisposeBag = DisposeBag()
    private var viewModel: SearchViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ApplicationMode.shared.mode.value == .bright ? .darkContent : .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCommonUI()
        bindUI()
        viewModel?.loadSearchHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch ApplicationMode.shared.mode.value {
        case .bright:
            configureBrightModeUI()
        case .dark:
            configureDarkModeUI()
        }
    }

    convenience init(viewModel: SearchViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    private func configureCommonUI() {
        view.addSubview(searchStackView)
        searchStackView.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(50)
        }
        
        view.addSubview(soundCollectionView)
        soundCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(searchHistoryTableView)
        searchHistoryTableView.snp.makeConstraints {
            $0.top.equalTo(searchStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptySearchResultView.addSubview(emptySearchResultLabel)
        emptySearchResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
        }
        
        view.addSubview(emptySearchResultView)
        emptySearchResultView.snp.makeConstraints {
            $0.top.equalTo(searchStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        emptySearchResultView.isHidden = true
    }
    
    private func configureBrightModeUI() {
        view.backgroundColor = .white
        searchBar.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchHistoryTableView.backgroundColor = .white
        soundCollectionView.backgroundColor = .white
        
        searchHistoryTableView.reloadData()
    }
    
    private func configureDarkModeUI() {
        view.backgroundColor = .black
        searchBar.backgroundColor = .black
        searchBar.searchTextField.textColor = .white
        searchHistoryTableView.backgroundColor = .black
        soundCollectionView.backgroundColor = .black
        
        searchHistoryTableView.reloadData()
    }
    
    private func bindUI() {
        ApplicationMode.shared.mode
            .bind { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .bright:
                    self.configureBrightModeUI()
                case .dark:
                    self.configureDarkModeUI()
                }
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel?.searchHistory
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                self?.searchHistoryTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel?.searchResult
            .skip(1)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if $0.isEmpty {
                    let colorForMode: UIColor = ApplicationMode.shared.mode.value == .bright ? .black : .white
                    self.emptySearchResultLabel.textColor = colorForMode
                    self.searchHistoryTableView.isHidden = false
                    self.emptySearchResultView.isHidden = false
                    return
                }
                
                self.searchHistoryTableView.isHidden = true
                self.emptySearchResultView.isHidden = true
                self.soundCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        viewModel?.saveSearchKeyword(keyword: keyword)
        viewModel?.search(keyword: keyword)
        dismissKeyboard()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchHistory = viewModel?.searchHistory.value[indexPath.item] ?? ""
        viewModel?.search(keyword: searchHistory)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .gray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchHistory.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchTableViewCell = tableView.dequeueReusableCell()
        else { return UITableViewCell() }
        
        cell.searchHistory.text = viewModel?.searchHistory.value[indexPath.item]
        
        if indexPath.item == 0 {
            cellDisposeBag = DisposeBag()
        }
        
        cell.configureUI()
        cell.deleteButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel?.removeSearchHistory(at: indexPath.item)
            }
            .disposed(by: cellDisposeBag)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = viewModel?.searchResult.value[indexPath.item] ?? Media()
        let musicPlayerViewController = MusicPlayerViewController(
            viewModel: MusicPlayerViewModel(
                media: media
            )
        )
        navigationController?.pushViewController(musicPlayerViewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = (collectionView.frame.size.width-32)/2-6
        return CGSize(width: cellWidth, height: cellWidth * MediaCell.ratio)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.searchResult.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MusicCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            return  UICollectionViewCell()
        }
        let media = viewModel?.searchResult.value[indexPath.item] ?? Media()
        cell.titleView.text = media.name
        cell.imageView.image = UIImage(named: media.thumbnailImageFileName)
        let colorHexString = viewModel?.searchResult.value[indexPath.item].color ?? "FFFFFF"
        cell.backgroundColor = UIColor(
            rgb: Int(colorHexString, radix: 16) ?? 0xFFFFFF,
            alpha: 1.0
        )
        return cell
    }
}
