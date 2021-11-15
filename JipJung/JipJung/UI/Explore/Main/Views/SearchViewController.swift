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
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .darkGray
        
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
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: UITableView.CellIdentifier.search.value)
        
        return searchHistoryTableView
    }()
    
    // MARK: - Private Variables
    
    private var disposeBag: DisposeBag = DisposeBag()
    private var cellDisposeBag: DisposeBag = DisposeBag()
    private var viewModel: SearchViewModel?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureUI()
        bindUI()
        viewModel?.loadSearchHistory()
    }
    
    // MARK: - Initializer

    convenience init(viewModel: SearchViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(searchStackView)
        searchStackView.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        view.addSubview(searchHistoryTableView)
        searchHistoryTableView.snp.makeConstraints {
            $0.top.equalTo(searchStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel?.searchHistory
            .bind(onNext: { [weak self] _ in
                self?.searchHistoryTableView.reloadData()
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
        dismissKeyboard()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchHistory.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cell(identifier: UITableView.CellIdentifier.search.value, for: indexPath) as? SearchTableViewCell
        else { return UITableViewCell() }
        
        cell.searchHistory.text = viewModel?.searchHistory.value[indexPath.item]
        
        if indexPath.item == 0 {
            cellDisposeBag = DisposeBag()
        }
        
        cell.deleteButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel?.removeSearchHistory(at: indexPath.item)
            }
            .disposed(by: cellDisposeBag)
        return cell
    }
}
