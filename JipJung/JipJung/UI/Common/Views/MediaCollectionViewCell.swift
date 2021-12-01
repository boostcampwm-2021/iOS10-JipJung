//
//  MusicCardCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit
import SnapKit

class MediaCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(systemName: "photo")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel(frame: frame)
        label.text = "몰디브 자연음"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeCircle()
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(imageView)
        let frame = self.frame
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
            $0.top.equalToSuperview().offset(frame.width * 0.2)
        }
        addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(frame.width * 0.2)
        }
    }
}
