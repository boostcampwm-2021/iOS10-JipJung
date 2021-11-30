//
//  SearchViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    // MARK: - Subviews
    
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
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.darkGray, for: .normal)
        
        return cancelButton
    }()
    
    private lazy var searchStackView: UIStackView = {
        let searchStackView = UIStackView(arrangedSubviews: [searchBar, cancelButton])
        searchStackView.axis = .horizontal
        searchStackView.spacing = 6
        
        return searchStackView
    }()
    
    private lazy var searchHistoryTableView: UITableView = {
        let searchHistoryTableView = UITableView()
        searchHistoryTableView.backgroundColor = .black
        searchHistoryTableView.separatorStyle = .none
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        return searchHistoryTableView
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
    private var cellDisposeBag: DisposeBag = DisposeBag()
    private var viewModel: SearchViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ApplicationMode.shared.mode.value == .bright ? .darkContent : .lightContent
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
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

    // MARK: - Initializer

    convenience init(viewModel: SearchViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Helpers
    
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
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
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
        self.searchHistoryTableView.isHidden = true
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
        self.searchHistoryTableView.isHidden = true
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
        navigationController?.pushViewController(MusicPlayerViewController(viewModel: MusicPlayerViewModel(media: media)), animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-32)/2-6, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.searchResult.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MusicCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else { return  UICollectionViewCell() }
        let media = viewModel?.searchResult.value[indexPath.item] ?? Media()
        cell.titleView.text = media.name
        cell.imageView.image = UIImage(named: media.thumbnailImageFileName)
        let colorHexString = viewModel?.searchResult.value[indexPath.item].color ?? "FFFFFF"
        cell.backgroundColor = UIColor(rgb: Int(colorHexString, radix: 16) ?? 0xFFFFFF,
                                       alpha: 1.0)
        return cell
    }
}
