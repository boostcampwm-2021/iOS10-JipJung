//
//  DummyCell.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    lazy var searchHistory: UILabel = {
        let searchHistory = UILabel()
        searchHistory.textColor = .white
        
        return searchHistory
    }()
    
    lazy var deleteButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.tintColor = .white
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        
        return cancelButton
    }()
    
    lazy var searchHistoryStackView: UIStackView = {
        let searchHistoryStackView = UIStackView(arrangedSubviews: [searchHistory, deleteButton])
        searchHistoryStackView.axis = .horizontal
        searchHistoryStackView.spacing = 6
        
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
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .black
        
        contentView.addSubview(searchHistoryStackView)
        searchHistoryStackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}
