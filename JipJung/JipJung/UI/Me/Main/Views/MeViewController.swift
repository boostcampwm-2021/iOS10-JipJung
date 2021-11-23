//
//  MeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit

import SnapKit

class MeViewController: UIViewController {
    private lazy var meCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let meCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        meCollectionView.dataSource = self
        meCollectionView.delegate = self
        meCollectionView.register(MeDailyStaticsCollectionViewCell.self)
        meCollectionView.register(MeMonthYearStaticsCollectionViewCell.self)
        meCollectionView.register(MeExtraCollectionViewCell.self)
        meCollectionView.backgroundColor = .clear
        return meCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationbar()
        configureCollectionView()
    }
    
    private func configureNavigationbar() {
        self.navigationItem.title = "hi friends"
    }
    
    private func configureCollectionView() {
        view.addSubview(meCollectionView)
        meCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell: MeDailyStaticsCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) {
                return cell
            }
        case 1:
            if let cell: MeMonthYearStaticsCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) {
                return cell
            }
        case 2:
            if let cell: MeExtraCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) {
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MeCollectionViewSize.width, height: MeCollectionViewSize.width)
    }
}
