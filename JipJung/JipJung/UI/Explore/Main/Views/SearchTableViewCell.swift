//
//  DummyCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    lazy var searchHistory = UILabel()
    lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .custom)
        deleteButton.tintColor = .darkGray
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.backgroundColor = .clear
        
        return deleteButton
    }()
    
    lazy var searchHistoryStackView: UIStackView = {
        let searchHistoryStackView = UIStackView(arrangedSubviews: [searchHistory, deleteButton])
        searchHistoryStackView.axis = .horizontal
        searchHistoryStackView.spacing = 20
        
        return searchHistoryStackView
    }()
    
    // MARK: - Initializers
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configureUI() {
        selectionStyle = .none
        
        contentView.addSubview(searchHistoryStackView)
        searchHistoryStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        switch ApplicationMode.shared.mode.value {
        case .bright:
            backgroundColor = .white
            searchHistory.textColor = .black
        case .dark:
            backgroundColor = .black
            searchHistory.textColor = .white
        }
    }
}
