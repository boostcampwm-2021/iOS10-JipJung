//
//  HomeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit

import SnapKit

class HomeViewController: UIViewController {
    private let mainScrollView = UIScrollView()
    private let mainScrollContentsView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    
    private let topViewHeight = 120
    private let bottomViewHeight = 800
    private let topBottomYGap = 450
    private let statusHeight = 47
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureMainScrollView()
        configureTopView()
        configureBottomView()
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        mainScrollView.backgroundColor = .orange
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainScrollView.addSubview(mainScrollContentsView)
        mainScrollContentsView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func configureTopView() {
        topView.backgroundColor = .cyan
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(topViewHeight)
        }
    }
    
    private func configureBottomView() {
        bottomView.backgroundColor = .red
        mainScrollContentsView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topBottomYGap + topViewHeight)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(bottomViewHeight)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentsOffsetY = scrollView.contentOffset.y
        let currentTopBottomYGap = topBottomYGap - (Int(currentContentsOffsetY) + statusHeight)
        topView.snp.updateConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(min(0, currentTopBottomYGap))
        }
    }
}
