//
//  MaximCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/16.
//

import UIKit

final class MaximCollectionViewCell: UICollectionViewCell {
    private(set) lazy var closeButton: UIButton = {
        let button = CloseButton()
        button.tintColor = .white
        return button
    }()
    private(set) lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .white
        button.imageView?.frame = .init(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 70)
        label.textColor = .white
        label.text = "15"
        return label
    }()
    private(set) lazy var monthYearLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .white
        label.text = "NOV 2021"
        return label
    }()
    private(set) lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.text = "In fact, in order to understand the real Chinaman, and the Chinese civilisation, a man must be depp, broad and simple."
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 10)
        return label
    }()
    private(set) lazy var seperateLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 5))
        view.backgroundColor = .systemGray3
        return view
    }()
    private(set) lazy var speakerLabel: UILabel = {
        let label = UILabel()
        var font = UIFont.preferredFont(forTextStyle: .subheadline)
        if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
            font = UIFont(descriptor: fontDescriptor, size: 0)
        }
        label.font = font
        label.textColor = .systemGray3
        label.text = "Schloar, Gu Hongming"
        return label
    }()
    
    var isShown = false {
        willSet {
            if newValue {
                UIView.animate(withDuration: 2, delay: 0, options: [], animations: ({ [weak self] in
                    self?.contentLabel.alpha = 1
                }))
            } else {
                self.contentLabel.alpha = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .black
        
        addSubview(speakerLabel)
        speakerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addSubview(seperateLine)
        seperateLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(speakerLabel.snp.top).offset(-20)
            $0.width.equalTo(30)
            $0.height.equalTo(5)
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(seperateLine.snp.top).offset(-30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        addSubview(monthYearLabel)
        monthYearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(contentLabel.snp.top).offset(-30)
        }
        
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalTo(monthYearLabel.snp.top)
        }
    }
}
