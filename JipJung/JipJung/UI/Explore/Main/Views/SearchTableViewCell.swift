//
//  DummyCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import UIKit

import SnapKit

final class SearchTableViewCell: UITableViewCell {
    lazy var searchHistory = UILabel()
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .darkGray
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    lazy var searchHistoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchHistory, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
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
