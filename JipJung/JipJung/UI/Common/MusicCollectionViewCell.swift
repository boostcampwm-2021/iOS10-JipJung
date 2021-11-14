//
//  MusicCardCollectionViewCell.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit
import SnapKit

class MusicCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel(frame: frame)
        label.text = "몰디브 자연음"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32)
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
        backgroundColor = .cyan.withAlphaComponent(0.5)
        addSubview(imageView)
        let frame = self.frame
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
            make.top.equalToSuperview().offset(frame.width * 0.115)
        }
        addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(frame.width * 0.115)
        }
    }
}
